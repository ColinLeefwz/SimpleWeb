# coding: utf-8

class AroundmeController < ApplicationController
  before_filter :user_login_filter, :only => [:my4, :my_shops, :hot_users, :shops, :report_error]
  before_filter :user_is_session_user, :only => [:my4, :my_shops]
  
  caches_action :users, :expires_in => 24.hours, :cache_path => Proc.new { |c| c.params }

  def my4
    arr = $redis.zrange("LL3#{params[:user_id]}",0,3,withscores:true)
    arr = arr.map{|x| [Shop.find_by_id(x[0]),x[1].to_i]}.find_all{|x| x[0]!=nil}
    ret = arr.map {|x| x[0].safe_output_with_users.merge!({time:Checkin.time_desc(x[1]), timei:x[1]})}
    render :json =>  ret.to_json
  end
  
  def my_shops
    lo = [params[:lat].to_f,params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    city = Shop.get_city(lo)
    arr = session_user.groups
    staffs = session_user.belong_shops
    arr = arr + staffs if staffs.size>0
    my_loc = session_user.my_loc
    arr = arr + my_loc.shops if my_loc
    arr.uniq!
    ret = arr.find_all{|x| x!=nil}.map do |x|  
      hash = x.safe_output_with_users
      ghash = x.group_hash(session[:user_id])
      #logger.info ghash
      hash.merge!(ghash)
      hash
    end
    coupons = $redis.smembers("ACS#{city}") 
    if coupons
      ret.each_with_index do |xx,i|
        ret[i]["coupon"] = 1 if coupons.index(xx["id"].to_i.to_s)
      end
    end
    render :json =>  ret.to_json
  end
  
  def hot
    lo = [params[:lat].to_f,params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    city = Shop.get_city(lo)
    arr = []
    if User.is_kx?(session[:user_id])
      $redis.smembers("FakeShops").each {|id| arr << Shop.find_by_id(id)}
    end
    if is_co_user?(session[:user_id])
      $redis.smembers("CoShops").each {|id| arr << Shop.find_by_id(id)}
    end
    if city
      shop = Shop.find_by_id(21838725) # 行酷车友会
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="023"
      shop = Shop.find_by_id(21839246) # 重庆的2014我们在一起
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="023"
      shop = Shop.find_by_id(21838424) # 铜梁安居古城
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end    
    if city && city=="0571"
      shop = Shop.find_by_id(21831686) # 西溪印象城
      if shop
        arr = arr[0,3]+[ shop ]+arr[3..-1]
      end
    end
    if city && city=="023" && lo[0].to_s[0,4]=="29.8" && lo[1].to_s[0,5]=="106.0" 
      shop = Shop.find_by_id(21839992) # 铜梁脸脸
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="023" && lo[0].to_s[0,4]=="29.3" && ( lo[1].to_s[0,5]=="105.9" || lo[1].to_s[0,5]=="105.8")
      shop = Shop.find_by_id(21840462) # 永川脸脸 [29.348392999999998, 105.913615]
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    arr.uniq!
    ret = arr.find_all{|x| x!=nil}.map do |x|  
      hash = x.safe_output_with_users
      ghash = x.group_hash(session[:user_id])
      #logger.info ghash
      hash.merge!(ghash)
      hash
    end
    coupons = $redis.smembers("ACS#{city}") 
    if coupons
      ret.each_with_index do |xx,i|
        ret[i]["coupon"] = 1 if coupons.index(xx["id"].to_i.to_s)
      end
    end
    render :json =>  ret.to_json
  end
  
  def shops
    if session[:user_id] && User.is_shop_id?(session[:user_id])
      ret = session_user.all_shops.map {|x| x.safe_output_with_users}
      return render :json =>  ret.to_json
    end
    fake_city = $redis.get("FCITY#{session[:user_id]}")
    if fake_city
      roam(fake_city)
      return
    end
    lo = [params[:lat].to_f,params[:lng].to_f]
    if lo[0]<0.00001 && lo[1]<0.00001 && params[:accuracy].to_i<1
      render :json =>  {error:"无法获得位置信息"}.to_json
      return
    end
    gps = nil
    wifi = nil
    if params[:baidu].to_i==1
      lo1 = Shop.lob_to_lo(lo) if params[:accuracy].to_i>=1
      if params[:gps] && params[:gps].size>0
        begin
          gps = ActiveSupport::JSON.decode(params[:gps])
          acc2 = gps["Accuracy"].to_i
          lo2 = [gps["Latitude"],gps["Longitude"]] if acc2>=1
        rescue Exception => e
          Xmpp.error_notify("gps:#{e.backtrace[0..3]}\n#{params[:gps]}\n")
        end
      end
      if params[:wifi] && params[:wifi].size>0
        begin
          wifi = ActiveSupport::JSON.decode(params[:wifi])
        rescue Exception => e
          Xmpp.error_notify("wifi:#{e.backtrace[0..3]}\n#{params[:wifi]}")
        end
      end
      lo = lo1
      lo = lo2 if lo.nil?
    end
    arr = find_shop_cache(lo,params[:accuracy].to_f,session[:user_id],params[:bssid]) 
    Rails.cache.write("LLOC#{session[:user_id]}",[lo,params[:accuracy].to_f,params[:bssid]]) 
    record_gps(lo, gps, wifi)
    if User.is_kx?(session[:user_id])
      $redis.smembers("FakeShops").each {|id| arr << Shop.find_by_id(id)}
    end
    if is_co_user?(session[:user_id])
      $redis.smembers("CoShops").each {|id| arr << Shop.find_by_id(id)}
    end
    if session_user #本人加入的群定位时总是出现
      if Rails.cache.read("PHONEREG#{session_user.id}")
        arr = session_user.groups + arr  #手机号码注册用户首次定位
      else
        head = arr[0..2]
        tail = arr[3..-1]
        arr = head + session_user.groups
        arr = arr + tail if tail
        staffs = session_user.belong_shops
        arr = arr + staffs if staffs.size>0
      end
    end
    city = get_city(arr[0], lo)
    #response.headers['Cpcity'] = URI::encode(City.cascade_name(city)) if city
    if city
      shop = Shop.find_by_id(21838725) # 行酷车友会
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="023"
      shop = Shop.find_by_id(21839246) # 重庆的2014我们在一起
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="0571"
      shop = Shop.find_by_id(21831686) # 西溪印象城
      if shop
        arr = arr[0,3]+[ shop ]+arr[3..-1]
      end
    end
    if city && city=="023" && lo[0].to_s[0,4]=="29.8" && lo[1].to_s[0,5]=="106.0" 
      shop = Shop.find_by_id(21839992) # 铜梁脸脸
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    if city && city=="023" && (lo[0].to_s[0,4]=="29.3" || lo[0].to_s[0,4]=="29.4" || lo[0].to_s[0,4]=="29.2") && ( lo[1].to_s[0,5]=="105.9" || lo[1].to_s[0,5]=="105.8")
      shop = Shop.find_by_id(21840462) # 永川脸脸 [29.348392999999998, 105.913615]
      if shop
	      shop.city = city
        arr = arr+[ shop ]
      end
    end
    arr.uniq!
    ret = arr.find_all{|x| x!=nil}.map do |x|  
      hash = x.safe_output_with_users
      ghash = x.group_hash(session[:user_id])
      #logger.info ghash
      hash.merge!(ghash)
      hash
    end
    coupons = $redis.smembers("ACS#{city}") 
    if coupons
      ret.each_with_index do |xx,i|
        ret[i]["coupon"] = 1 if coupons.index(xx["id"].to_i.to_s)
        ret[i].delete("coupon") if ret[i]["id"].to_i == 21838725  # 行酷车友会
        ret[i]["city"] = City.city_name(city) if i==0
      end
    end
    render :json =>  ret.to_json
  end

  def shop_report
    if Rails.env == 'production'		
		lo = [params[:lat].to_f,params[:lng].to_f]
		lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
		arr = find_shop_cache(lo,params[:accuracy].to_f,params[:uid],params[:bssid])
		@shops = arr.map do |x|
		  [x['name'],x['_id'].to_i]
		end
	else
		@shops = Shop.where({}).limit(30).map{|m| [m.name, m.id]}
	end
    render :layout => false

  end

  def report
    user = User.find_by_id(params[:uid])
    if user.nil?
      render :json => ""
    else
      shop = Shop.find_by_id(params[:sid])
      ShopReport.create(:uid => user.id, :sid => params[:sid], :name => shop.name, :des => params[:des], :type => params[:type] )
      render :json => ''
    end
  end
  
  def report_error
    shop = Shop.find_by_id(params[:sid])
      ShopReport.create(:uid => session_user.id, :sid => params[:sid], :name => shop.name, :des => params[:des], :type => params[:type] )
      render :json => {ok:params[:sid]}.to_json
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
    users = User.where({pcount: {"$gt" => 2}}).sort({_id:-1}).limit(4)
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
    city = $redis.get("FCITY#{session[:user_id]}")
    city = Shop.get_city(lo) if city.nil?
    if params[:gender].to_i==0
      sex = session_user.gender
      sex = (sex==2? 1:2)
    elsif params[:gender].to_i==1
      sex = 1
    else
      sex = 2
    end
    users = hot_users_no_cache(city,sex,skip,pcount)
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

  def record_gps(lo,gps,wifi)
    hash = {uid:session[:user_id], lo:lo, acc:params[:accuracy]}
    hash.merge!(bssid:params[:bssid]) if params[:bssid]
    hash.merge!(bd:params[:baidu]) if params[:baidu]
    if params[:speed]
      speed = params[:speed].to_f 
      hash.merge!(speed:speed) if speed>0.1
    end
    hash.merge!(gps:gps) if gps
    hash.merge!(wifi:wifi) if wifi
    GpsLog.collection.insert(hash)
    #Resque.enqueue(GpsRecord, hash)
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
    if city && city.length>1
      city2 = City.next_city(city,page)
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
  
  def in_hubin_intime?(hb_shop, lo, acc)
    diff = hb_shop.min_distance(hb_shop,lo)
    return diff < 500+acc
  end
  
  def get_city(shop, lo)
    city = shop["city"]
    city = Shop.get_city(lo)  if city.nil? || city=="" || city=="0998" #喀什
    city
  end
  
  def roam(city)
    uids = $redis.zrevrange("HOT1U#{city}",0,20) + $redis.zrevrange("HOT2U#{city}",0,20)
    arr = uids.map do |uid|
      user = User.find_by_id(uid)
      if user
        loc = user.last_loc
        if loc==nil || loc[-1].class == Array
          nil
        else
         Shop.find_by_id(loc[-1])
       end
      else
        nil
      end
    end
    arr.delete_if{|x| x==nil}
    arr.uniq!
    Rails.logger.error(arr)
    #response.headers['Cpcity'] = URI::encode(City.cascade_name(city))
    ret = arr.map do |x| 
      hash = x.safe_output_with_users
      ghash = x.group_hash(session[:user_id])
      hash.merge!(ghash)
      hash
    end
    coupons = $redis.smembers("ACS#{city}") 
    if coupons
      ret.each_with_index do |xx,i|
        ret[i]["coupon"] = 1 if coupons.index(xx["id"].to_i.to_s)
        ret[i]["city"] = City.city_name(city) if i==0
      end
    end
    render :json =>  ret.to_json
  end

end
