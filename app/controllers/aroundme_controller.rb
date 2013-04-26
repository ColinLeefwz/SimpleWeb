# coding: utf-8

class AroundmeController < ApplicationController
  before_filter :user_login_filter, :only => :hot_users
  caches_action :users, :expires_in => 24.hours, :cache_path => Proc.new { |c| c.params }
  
  def shops
    lo = [params[:lat].to_f,params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    arr = Shop.new.find_shops(lo,params[:accuracy].to_f,session[:user_id],params[:bssid])  
    record_gps(lo)
    if session[:user_id].to_s == "5160f00fc90d8be23000007c" || 
      session[:user_id].to_s == "512aeb11c90d8ba3020000d0" ||
      session[:user_id].to_s == "502e6303421aa918ba000001" ||      
      session[:user_id].to_s == "5159537cc90d8bfd010009cc"
      Coupon.where({t2:1}).last.send_coupon(session[:user_id])
    end
    if is_session_user_kx
      arr << Shop.find_by_id($llcf)
      arr << Shop.find_by_id($llsc)
    end
    if in_zi_wei_yuan_dian?(lo)
      arr << Shop.find_by_id(21830231) #延安路•紫微大街 
    end
    render :json =>  arr.map{|x| x.safe_output_with_users}.to_json
  end

  def shop_report
    lo = [params[:lat].to_f,params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    arr = Shop.new.find_shops(lo,params[:accuracy].to_f,params[:uid],params[:bssid])
    @shops = arr.map do |x|
      [x['name'],x['_id'].to_i]
    end
    render :layout => false
  end

  def report
    user = User.find_by_id(params[:uid])
    if user.nil?
      render :json => ""
    else
      ShopReport.create(:uid => user.id, :sid => params[:sid], :des => params[:des] )
      render :json => ''
    end
  end
  
  def shop2
    (params[:user].nil? || params[:user]=="")? uid="": uid=User.find_by_id(params[:user].gsub(/\s+/, "")).id
    if params[:loc] && params[:loc].length>3
      lob = params[:loc].split(/[,]/).map { |m| m.to_f  }.reverse
      loc = Shop.lob_to_lo(lob)
      @shops = Shop.new.find_shops(loc,params[:accuracy].to_f,uid,params[:bssid],true)  
    elsif params[:lo]
      loc = params[:lo].split(/[,]/).map { |m| m.to_f  }
      @shops = Shop.new.find_shops(loc,params[:accuracy].to_f,uid,params[:bssid],true)
    else
      @shops = []
    end
  end
  
  def users
    ret = []
    users = User.where({pcount: {"$gt" => 2}}).limit(4)
    users.each {|u| ret << u.safe_output(session[:user_id]) }
    if ret
      render :json => ret.to_json
    else
      render :json => [].to_json
    end
  end
  
  def hot_users
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    lo = [params[:lat].to_f , params[:lng].to_f]
    city = Shop.get_city(lo)
    sex = session_user.gender
    users = hot_users_no_cache(city,sex,skip,pcount)
    ret = users.map do |u| 
      hash = u.safe_output_with_location(session[:user_id])
      last = hash[:last].split()
      if last.size>=3
        time = last[0]+" "+last[1]
      else
        time = "1 day"
      end
      hash.merge!({time: time})
      hash
    end
    render :json => ret.to_json
  end
  
  private 

  def record_gps(lo)
    hash = {uid:session[:user_id], lo:lo, acc:params[:accuracy]}
    hash.merge!(bssid:params[:bssid]) if params[:bssid]
    hash.merge!(bd:params[:baidu]) if params[:baidu]
    GpsLog.collection.insert(hash)
  end
  
  def hot_user_cache_key(city,sex,skip,pcount)
    "HOTU#{city}#{sex}#{skip}#{pcount}"
  end
  
  def hot_users_no_cache(city,sex,skip,pcount)
    sex==1? sexa=2 : sexa=1
    sex==1? sexb=1 : sexb=2 
    uids = $redis.zrevrange("HOT#{sexa}U#{city}",skip,skip+pcount-1)
    diff = uids.size-pcount
    if diff>0
     uids += $redis.zrevrange("HOT#{sexb}U#{city}",skip,skip+diff-1)
    end
    diff = uids.size-pcount
    if diff>0
      if city.length>1
        uids += $redis.zrevrange("HOT#{sexa}U",skip,skip+diff-1)
      else
        uids += $redis.zrevrange("HOT#{sexa}U010",skip,skip+diff-1) 
      end
    end
    users = uids.map{|id| User.find_by_id(id)}.find_all{|x| x != nil}
    users
  end
  
  def hot_users_cache(city,sex,skip,pcount)
    Rails.cache.fetch(hot_user_cache_key(city,sex,skip,pcount), :expires_in => 60.minutes) do 
      hot_users_no_cache(city,sex,skip,pcount)
    end
  end
  
  def in_zi_wei_yuan_dian?(lo)
    lo[0] < 30.26082 && lo[0] > 30.2431 && lo[1] > 120.15379 && lo[1] < 120.164
    #[30.26081567, 120.1537979]  [30.26064367, 120.16330190000001] 
    #[30.24317747, 120.1573636]  [30.24311447, 120.1620166] 
  end
  
end
