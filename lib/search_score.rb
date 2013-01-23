# coding: utf-8

module SearchScore

  def find_shops(loc,accuracy,ip,uid,bssid=nil,debug=false)
    radius = 0.0016+0.002*accuracy/300
    radius=0.01 if(radius>0.01)  #不大于1000米
    arr = Shop.collection.find({lo:{"$near" =>loc,"$maxDistance"=>radius}}).limit(100).to_a
    arr.uniq_by! {|x| x["_id"]}
    if arr.length>=3
      return sort_with_score(arr,loc,accuracy,ip,uid,bssid,debug)
    else
      arr = Shop.collection.find({lo:{"$near" =>loc}}).limit(10).to_a
      arr.uniq_by! {|x| x["_id"]}
      return sort_with_score(arr,loc,accuracy,ip,uid,bssid,debug)[0,5]
    end
  end
  
  def sort_with_score(arr,loc,accuracy,ip,uid,bssid,debug=false)
    score = arr.map {|x| [x,min_distance(x,loc),0]}
    min_d = score[0][1]
    score.reject!{|s| (s[0]["t"]==0 && s[0]["del"]) } #过期的活动
    if score.length>10
      score.reject!{|s| s[0]["del"] }
    end
    if score.length>5
      score = score[0,6]+score[6..-1].reject{|s| bad?(s) }
    end
    score.each do |xx|
      x=xx[0]
      base_score(xx,x)
      shop_history_score(xx,x,ip,"ObjectId(\"#{uid}\")")      
    end
    bssid_score(score,bssid) if bssid
    realtime_score(score)
    score.each_with_index do |xx,i|
      xx[2] =  adjust(xx[2],accuracy,min_d)
      xx[1] += xx[2]
    end
    score.sort! {|a,b| a[1]<=>b[1]}
    if score.length>9
      ret = score[0,9]+score[9..-1].reject{|s| bad?(s) }
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
  
  def bad?(shop)
    shop[0]["d"] || shop[0]["t"].nil? || shop[0]["del"]
  end
  
  def adjust(score,accuracy,min_d)
    ret = score
    ret = -200 if ret < -200 #最多加权2/3后封顶
    acc = accuracy
    acc = 30 if acc<30
    acc = 1000 if acc>1000
    ret = ret*(0.1+acc/300.0)
    return ret if min_d<acc #如果最近的点在误差范围之内
    factor = (min_d-acc)/30.0
    factor = 3 if factor>3
    return ret*(1+factor)
  end
  
  def realtime_score(score)
    shop_ids = score.map{|x| x[0]["_id"].to_i}
    Checkin.get_users_count_multi(shop_ids).map{|x| user_to_score(x)}.each_with_index do |s,i|
      score[i][2] -= s 
    end
  end

  def bssid_score(score,bssid)
    b = CheckinBssidStat.where({"_id" => bssid}).first
    unless b.nil?
      score.each_with_index do |xx,i|
        bshop = b.shops.find{|shop| shop["id"]==xx[0]["_id"]}
        next if bshop.nil?
        xx[1] -= (30/b.shops.size+(bshop["users"].size-1)*50)
      end
    end
  end  
  
  def shop_history_score(xx,x,ip,uid_s)
      sc = CheckinShopStat.find_by_id(x["_id"].to_i)
      return if sc.nil?
      if uid_s && sc.users[uid_s]
        ucount = sc.users[uid_s][0]
        xx[2] -= ucount*30
        xx[2] -= user_to_score(sc.users.length)/2.0
      end

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
    if (t==4)
      if(hour>=11 && hour<=13) 
        xx[2]-=20 
      elsif (hour>=17 && hour<=19)
        xx[2]-=20
      elsif (hour>20)
        xx[2]+= 10*(hour-20)
      elsif (hour<10)
        xx[2]+= 10*(10-hour)
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
