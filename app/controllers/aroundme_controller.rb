# coding: utf-8

class AroundmeController < ApplicationController
  before_filter :user_login_filter, :only => [:hot_users, :shops]
  caches_action :users, :expires_in => 24.hours, :cache_path => Proc.new { |c| c.params }
  
  #  $qb_seller = [
  #    "517ccc0ac90d8b49ef000033", #兵临城下
  #    "516bc8cbc90d8b5663000019", #兵临城下
  #    "50dc0d25c90d8bc42a000098", #若博斯
  #    "519084ddc90d8bc2ee00002c", #蓶ーDéィ衣賴
  #    "50fde347c90d8b8b7f0000d1", #muak-婷
  #    "5170d235c90d8b07e8000052", #游源土人
  #    "50f8e2ebc90d8bb4260000aa", #大安
  #    "519987b0c90d8bdb32000072", #油条
  #    "512b60bec90d8b401e000135", #3+
  #  ]
  
  def shops
    lo = [params[:lat].to_f,params[:lng].to_f]
    if params[:baidu].to_i==1
      lo1 = Shop.lob_to_lo(lo) if params[:accuracy].to_i>1
      if params[:gps]
         begin
           gps = ActiveSupport::JSON.decode(params[:gps]) 
           acc2 = gps["Accuracy"].to_i
           lo2 = [gps["Latitude"],gps["Longitude"]] if acc2>1
         rescue Exception => e
           logger.error e
         end
      end
      if lo2.nil?
        lo = lo1
      elsif lo1.nil?
        lo = lo2
      else
        lo = Shop.new.mid_loc(lo1,params[:accuracy],lo2,acc2)
      end
    end
    arr = find_shop_cache(lo,params[:accuracy].to_f,session[:user_id],params[:bssid])  
    record_gps(lo)
    if is_kx_user?(session[:user_id])
      arr << Shop.find_by_id(21830784)
      arr << Shop.find_by_id(21830785)
      arr << Shop.find_by_id(21830326)
      arr << Shop.find_by_id($llcf)
      arr << Shop.find_by_id($llsc)
      arr << Shop.find_by_id(21830231) #延安路•紫微大街 
    end
    if session_user #本人加入的群定位时总是出现
      if Rails.cache.read("PHONEREG#{session_user.id}")
        arr = session_user.groups + arr  #手机号码注册用户首次定位
      else
        head = arr[0..2]
        tail = arr[3..-1]
        arr = head + session_user.groups
        arr = arr + tail if tail
      end
    end
    ret = arr.map do |x| 
      hash = x.safe_output_with_users
      ghash = x.group_hash(session[:user_id])
      #logger.info ghash
      hash.merge!(ghash)
      hash
    end
    city = get_city(arr[0], lo)
    coupons = $redis.smembers("ACS#{city}") 
    if coupons
      ret.each_with_index do |xx,i|
        ret[i]["coupon"] = 1 if coupons.index(xx["id"].to_i.to_s)
        ret[i]["city"] = City.city_name(city) if i==0
      end
    end
    render :json =>  ret.to_json
  end

  def shop_report
    lo = [params[:lat].to_f,params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    arr = find_shop_cache(lo,params[:accuracy].to_f,params[:uid],params[:bssid])
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
    if params[:gender].to_i==0
      sex = session_user.gender
      sex = (sex==2? 1:2)
    elsif params[:gender].to_i==1
      sex = 1
    else
      sex = 2
    end
    users = hot_users_cache(city,sex,skip,pcount)
    ret = []
    users.each do |u|
      next if u.forbidden?
      next if u.invisible.to_i>=2
      output_hot_user(u,ret)
      break if ret.size>=pcount
    end
    render :json => ret.to_json
  end
  
  private 
  
  def output_hot_user(u,ret)
    hash = u.safe_output_with_location(session[:user_id])
    last = hash[:last].split()
    if last.size>=3
      time = last[0]+" "+last[1]
    else
      time = "1 day"
    end
    hash.merge!({time: time})
    ret << hash
  end

  def record_gps(lo)
    hash = {uid:session[:user_id], lo:lo, acc:params[:accuracy]}
    hash.merge!(bssid:params[:bssid]) if params[:bssid]
    hash.merge!(bd:params[:baidu]) if params[:baidu]
    if params[:speed]
      speed = params[:speed].to_f 
      hash.merge!(speed:speed) if speed>0.1
    end    
    GpsLog.collection.insert(hash)
  end
  
  def find_shop_key(lo,accu,uid)
    acc = accu>100? 1:0
    str = "#{uid}%.3f%.3f#{acc}" %  lo
    str
  end 
  
  def find_shop_cache(lo,accu,uid,bssid)
    Rails.cache.fetch(find_shop_key(lo,accu,uid), :expires_in => 60.minutes) do 
      find_shop_no_cache(lo,accu,uid,bssid)
    end    
  end
  
  def find_shop_no_cache(lo,accuracy,uid,bssid)
    Shop.new.find_shops(lo,accuracy,uid,bssid)  
  end
  
  
  def hot_user_cache_key(city,sex,skip,pcount)
    "HOTU#{city}#{sex}#{skip}#{pcount}"
  end
  
  def hot_users_no_cache(city,sex,skip,pcount)
    uids = $redis.zrevrange("HOT#{sex}U#{city}",skip,skip+pcount-1)
    page = (skip/pcount +1)
    city2 = city[0] + (city.to_i+page).to_s
    if city.length>1
      uids += $redis.zrevrange("HOT#{sex}U#{city2}",0,pcount-1)
    else
      uids += $redis.zrevrange("HOT#{sex}U010",skip,skip+pcount-1) 
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
  
  def get_city(shop, lo)
    city = shop["city"]
    city = Shop.get_city(lo)  if city.nil? || city==""
    city
  end
  
end
