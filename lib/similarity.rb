# coding: utf-8

module Similarity
  include Gps
  
  def trim(str)
  	str.sub!(/\./,"")
  	str.sub!(/\(/,"")
  	str.sub!(/\)/,"")
  	str.sub!(/（/,"")
  	str.sub!(/）/,"")	
  	str
  end
  
  def trim_province_prefix(str,province)
    ret = str
    if province[-1]=="省" || province[-1]=="市"
      p2 = province[0..-2]
    elsif province[-3..-1]=="自治区"
      p2 = province[0..-4]
      p2 = p2[0,2] if p2.length>3
    end
    ret = ret[province.length..-1] if ret.index(province)==0
    ret = ret[p2.length..-1] if ret.index(p2)==0
    ret
  end  
  
  def trim_city_prefix(str,city)
    ret = str
    if city[-1]=="县" || city[-1]=="市"
      ret = ret[city.length..-1] if ret.index(city)==0
      city2 = city[0..-2]
      ret = ret[city2.length..-1] if ret.index(city2)==0
    else
      city2 = city+"市"
      ret = ret[city2.length..-1] if ret.index(city2)==0
      ret = ret[city.length..-1] if ret.index(city)==0
    end
    ret
  end
  
  def trim_citys_province(str,citys,province)
    ret = trim_province_prefix(str,province)
    citys.each {|x| ret = trim_city_prefix(ret,x) }
    ret
  end
  
  def trim_type(str,t)
    if t==5
      str.sub(/(大酒店|酒店|旅馆|宾馆|客房)$/,"")
    else
      str
    end
  end

  def str_similar(str1,str2,citys,province,shop1,shop2)
  	s1 = trim(trim_citys_province(str1,citys,province))
  	s2 = trim(trim_citys_province(str2,citys,province))
    s1 = trim_type(s1,shop1["t"])
    s2 = trim_type(s2,shop2["t"])
    puts "#{s1} - #{s2}"
  	a1 = s1.split(//).to_set
  	a2 = s2.split(//).to_set
    a3 = a1 & a2
    m1 = (a3.size*1.0/a1.size)
    m2 = (a3.size*1.0/a2.size)
    return (m1+m2)/2
  end
  
  def distance(shop1,shop2)
    if(shop2["lo"][0].class==Array)
      loc = shop2["lo"][0]
    else
      loc = shop2["lo"]
    end
    if(shop1["lo"][0].class==Array)
      shop1["lo"].map {|x| get_distance(x,loc)}.min
    else
      return get_distance(shop1["lo"],loc)
    end
  end
  
  def similarity(shop1,shop2)
    citys = []
    province = nil
    City.where({code:shop1["city"]}).each do |x| 
      province = x.s
      citys << x.name
    end
    name_score = 70*str_similar(shop1["name"],shop2["name"],citys,province,shop1,shop2)
    addr_score = 12*str_similar(shop1["addr"],shop2["addr"],citys,province,shop1,shop2)
    type_score = 8*(shop1["t"]==shop2["t"]? 1:0)
    puts "distance#{distance(shop1,shop2)}"
    dist_score = 10-Math.log(distance(shop1,shop2)+1, 1.8)
    puts [name_score,addr_score,type_score,dist_score]
    return name_score+addr_score+type_score+dist_score
  end

  def similarity_by_id(id1,id2)
    return similarity(Shop.find(id1),Shop.find(id2))
  end
  
end
