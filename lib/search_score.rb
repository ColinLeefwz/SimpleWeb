# coding: utf-8

module SearchScore

  def find_shops(loc,accuracy,uid,bssid=nil,debug=false)
    radius = get_radius(accuracy)
    limit = 100
    hash = {lo:{"$near" =>loc,"$maxDistance"=>radius}}
    if bssid
      b = CheckinBssidStat.find_by_id(bssid)
      #TODO: 不查询CheckinBssidStat
      shopids = $redis.smembers("BSSID#{bssid}")
      shopids << b.shop_id if b && b.shop_id && !shopids.find{|x| x.to_i==b.shop_id.to_i}
      hash["_id"] = {"$nin" => shopids} if shopids.size>0
      if b && b.shop_id
        limit = 20
      else
        limit = 100 - shopids.size*5
        limit = 30 if limit<30
      end
    end
    arr = Shop.where(hash).limit(limit).to_a
    arr.uniq_by! {|x| x["_id"]}
    if shopids
      shopids.each do |x| 
        shop=Shop.find_by_id(x); 
        arr << shop if shop && min_distance(shop,loc)<1500
      end
    end
    if arr.length>=3
      return sort_with_score(arr,loc,accuracy,uid,bssid,debug)
    else
      arr = Shop.where({lo:{"$near" =>loc}}).limit(10).to_a
      arr.uniq_by! {|x| x["_id"]}
      return sort_with_score(arr,loc,accuracy,uid,bssid,debug)[0,5]
    end
  end
  
  def get_radius(accuracy)
    radius = 0.0016+0.002*accuracy/300
    radius=0.01 if(radius>0.01)  #不大于1000米
    radius
  end
  
  def sort_with_score(arr,loc,accuracy,uid,bssid,debug=false)
    score = arr.map {|x| [x,min_distance(x,loc),0]}
    min_d = score[0][1]
    score.reject!{|s| (s[0]["t"]==0 && s[0]["del"]) } #过期的活动
    if score.length>10
      score.reject!{|s| s[0]["del"] && !owner?(s,uid) }
    end
    if score.length>5
      score = score[0,6]+score[6..-1].reject{|s| bad?(s) && !owner?(s,uid) }
    end
    score.each do |xx|
      x=xx[0]
      base_score(xx,x)
      xx[2] -= 100 if owner?(xx,uid)
    end
    user = User.find_by_id(uid)
    if user && (Time.now.to_i-user.cati)>3600*24*7 && bssid.nil?
      score.each do |xx|
        x=xx[0]
        shop_history_score(xx,x,uid.to_s) unless bssid #没有wifi时，要更依赖历史推荐
      end
    end
    bssid_score(score,bssid) if bssid
    realtime_score(score)
    content_score(score)
    score.each_with_index do |xx,i|
      xx[2] =  adjust(xx[2],accuracy,min_d)
      xx[1] += xx[2]
    end
    score.sort! {|a,b| a[1]<=>b[1]}
    if score.length>9
      ret = score[0,9]+score[9..-1].reject{|s| bad?(s) && !owner?(s,uid) }
    else
      ret = score
    end
    if bad?(ret[0]) && !bad?(ret[1])
      ret = [ret[1],ret[0]]+ret[2..-1]
    end
    if debug
      return ret
    else
      return ret[0,30].map {|x| x[0]}
    end
  end
  
  def owner?(shop, uid)
    shop[0]["creator"] && uid.to_s == shop[0]["creator"].to_s
  end
  
  def bad?(shop)
    shop[0]["d"] || shop[0]["t"].nil? || shop[0]["del"]
  end
  
  def adjust(score,accuracy,min_d)
    ret = adjust0(score)
    acc = accuracy
    acc = 30 if acc<30
    acc = 1000 if acc>1000
    ret = ret*(0.05+acc/300.0)
    return ret if min_d<acc #如果最近的点在误差范围之内
    factor = (min_d-acc)/30.0
    factor = 3 if factor>3
    return ret*(1+factor)
  end
  
  def adjust0(score)
    ret = 0
    if score<-300
      ret = (score+300)*0.1
      score = -300
    end
    if score<-200
      ret += (score+200)*0.2
      score = -200
    end   
    ret = ret + score
    ret = -300 if ret < -300
    ret
  end
  
  #对当天有用户的商家加权
  def realtime_score(score)
    shop_ids = score.map{|x| x[0]["_id"].to_i}
    Checkin.get_users_count_today_multi(shop_ids).map{|x| user_to_score(x)}.each_with_index do |s,i|
      score[i][2] -= s 
    end
  end
  
  #对有问答和激活优惠券的商家加权
  def content_score(score)
    city = score[0][0].city
    faqs = $redis.smembers("FaqS#{city}")
    coupons = $redis.smembers("ACS#{city}") 
    score.each_with_index do |xx,i|
      xx[2] -= 30 if faqs.index(xx[0].id.to_i.to_s)
      xx[2] -= 80 if coupons.index(xx[0].id.to_i.to_s)
    end
  end

  #对用WIFI定位的加权
  def bssid_score(score,bssid)
    b = CheckinBssidStat.find_by_id(bssid)
    unless b.nil?
      score.each_with_index do |xx,i|
        xx[2] -= 300 if xx[0]["_id"]==b.shop_id
        bshop = b.shops.find{|shop| shop["id"]==xx[0]["_id"]}
        next if bshop.nil?
        if b.shop_id
          xx[2] -= (50/b.shops.size+(bshop["users"].size-1)*5)
        else
          xx[2] -= (50/b.shops.size+(bshop["users"].size)*20)
        end
      end
    end
  end  
  
  #对用户在商家的历史访问加权
  def shop_history_score(xx,x,uid_s)
      sc = Rails.cache.read("CheckinShopStat#{x['_id'].to_i}")
      return if sc.nil? || sc==-1
      if uid_s && sc.users[uid_s]
        ucount = sc.users[uid_s][0]
        xx[2] -= ucount_score(ucount)
      end
  end
  
  def ucount_score(c)
    return 30*c if c<=3
    return 90+10*(c-3) if c<=10
    return 150+c
  end
  
  def base_score(xx,x)
    t = x["t"]
    stype = x["type"]
    stype='' if(!stype)
    if t
      t = t.to_i
      xx[2]-=10 if t<4
      xx[2]-=20 if t==0
      xx[2]-=5 if t>=4 && t<50
      xx[2]+=60 if t==14 # 14:大型医院
    else
      xx[2] +=100
    end
    if x["shops"]
      xx[2]-=30
      xx[2]-=x["shops"].length
    end
    xx[2]-=10 if x["lo"][0].class==Array
    xx[2]+= (100+x["d"].to_i*5) if x["d"]
    xx[2]+=1000 if x["del"]
    len = x["name"].length
    xx[2] += (10+(len-11)*3) if len>11
    xx[2] += (10+(4-len)*3) if len<4
    xx[2] -= x["v"].to_i if x["v"]
    xx[2] -= 30 if x["password"] #开通密码的商家
    xx[2] -= user_to_score(x["utotal"].to_i)/2.0
    time_score(xx,x)
  end
  
  def time_score(xx,x)
    today = Time.now
    hour = today.hour
    hminute = hour*60+today.min
    t = x["t"]
    if t==1
      xx[2]-=30 if (hour>=20 || hour <=3)
      xx[2]+=20 if (hour>=6 || hour <=12)
    end
    if (t!=1 && t!=5 && t!=10 && t!=11 && t!=12 && t!=13 && t!=14)
      if (hour>20)
        xx[2]+= 10*(hour-20)
      elsif (hour<10)
        xx[2]+= 10*(10-hour)
      end
    end
    if (t==4)
      if(hour>=11 && hour<=13) 
        xx[2]-=20 
      elsif (hour>=17 && hour<=19)
        xx[2]-=20
      elsif (hminute>(14*60+30) && hminute<(16*60+30) )
        xx[2]+=10
      end
    end
    if t==11
      xx[2] -=10 if(hour>=20 || hour<=8)
    end
    if t==10
      if(today.wday>=1 && today.wday<=5)
        xx[2] -=10 if(hour>=14 && hour<=17)
        xx[2] -=10 if(hour>=8 && hour<=11)
        xx[2] +=10 if(hour>=19)
      else
        xx[2] +=10;
      end
    end
  end
  
  def user_to_score(uc)
    return 0 if uc==0
    return 10 if uc==1
    return 25 if uc==2
    return 55 if uc==3
    return 70 if uc==4
    return 80 if uc==5   
    return 80+4*(uc-5) if uc<=10
    return 100+uc-10
  end
  
end
