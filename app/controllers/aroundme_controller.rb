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
      session[:user_id].to_s == "5159537cc90d8bfd010009cc"
      Shop.find($llcf).send_coupon(session[:user_id])
    end
    if is_session_user_kx
      arr << Shop.find_by_id($llcf)
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
    users.each {|u| ret << u.safe_output_with_relation(session[:user_id]) }
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
    if sex==1
      sex=2
    else
      sex=1
    end
    arr = hot_users_cache(city,sex,skip,pcount)
    users = []
    arr.each do |user,shop,cati| 
      next if shop.nil?
      next if user.forbidden?
      next if user.block?(session[:user_id])
      next if user.id.to_s=="51145007c90d8b056a000796" #马甲Keri Choo	
      hash = user.safe_output_with_relation(session[:user_id])
      diff = Time.now.to_i - cati
      tstr = User.time_desc(diff)
      hash.merge!({location: "#{tstr} #{shop.name}"})
      users << hash
      break if users.size>=pcount
    end
    render :json => users.to_json
  end
  
  private 
  
  def user_to_score(uc)
    return uc*3 if(uc<=10) 
    return 75 if(uc>100) 
    return 30+(uc-10)/2
  end
  
  def record_gps(lo)
    hash = {uid:session[:user_id], lo:lo, acc:params[:accuracy]}
    hash.merge!(bssid:params[:bssid]) if params[:bssid]
    hash.merge!(bd:params[:baidu]) if params[:baidu]
    GpsLog.collection.insert(hash)
  end
  
  def hot_user_cache_key(city,sex,skip,pcount)
    "HOTU#{city}#{sex}#{skip}#{pcount}#{Date.today.to_s}"
  end
  
  def hot_users_no_cache(city,sex,skip,pcount)
    ckins = Checkin.where({city: city, sex:sex, sid:{"$ne" => $llcf}}).sort({_id:-1}).skip(skip*2).limit(pcount*2).to_a
    if ckins.size==0
      ckins = Checkin.where({city: {"$ne" => city}, sex:sex, sid:{"$ne" => $llcf}}).sort({_id:-1}).skip(skip*3).limit(pcount*2).to_a
    end
    ckins = ckins.uniq!{|x| x.uid}
    ckin2 = Checkin.where({city: city, sex:{"$ne" => sex}, sid:{"$ne" => $llcf}}).sort({_id:-1}).skip(skip*2).limit(pcount*2).to_a
    if ckin2.size==0
      ckin2 = Checkin.where({city: {"$ne" => city}, sex:{"$ne" => sex}, sid:{"$ne" => $llcf}}).sort({_id:-1}).skip(skip*3).limit(pcount*2).to_a
    end
    ckin2 = ckin2.uniq!{|x| x.uid}
    ckins = ckins + ckin2
    arr = ckins.map{|c| [c.user,c.shop,c.cati]}
    arr
  end
  
  def hot_users_cache(city,sex,skip,pcount)
    Rails.cache.fetch(hot_user_cache_key(city,sex,skip,pcount)) do 
      hot_users_no_cache(city,sex,skip,pcount)
    end
  end
  
end
