# coding: utf-8

module Similarity
  include Gps
  
  def trim(str)
    str.sub!(/\([^)]+\)/, "")
    str.sub!(/（[^）]+）/, "")
  	str.sub!(/\./,"")    
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
  
  def trim_town_prefix(str)
    return str[3..-1] if str.length>5 && (str[2]=="镇" || str[2]=="区")
    return str
  end
  
  def trim_citys_province(str,citys,province)
    ret = trim_province_prefix(str,province)
    citys.each {|x| ret = trim_city_prefix(ret,x) }
    trim_town_prefix(ret)
  end
  
  def trim_type(str,t)
    case t
    when 1 then str.sub(/(酒吧|club)$/i,"")
    when 2 then str.sub(/(咖啡|咖啡厅|咖啡屋|咖啡吧)$/i,"")
    when 3 then str.sub(/(茶馆|茶楼|茶艺|茶吧|茶园|茶庄)$/i,"")
    when 4 then str.sub(/(餐厅|店)$/,"")            
    when 5 then str.sub(/(大酒店|酒店|旅馆|宾馆|客房|旅店)$/,"")
    else str
    end
  end
  
  def trim_bracket(str)
    str.sub(/\([^)]+\)/, "")
  end
  
  def str_similar(s1,s2)
  	a1 = s1.split(//).to_set
  	a2 = s2.split(//).to_set
    a3 = a1 & a2
    m1 = (a3.size*1.0/a1.size)
    m2 = (a3.size*1.0/a2.size)
    (m1+m2)/2
  end

  def name_similar(str1,str2,citys,province,shop1,shop2)
  	s1 = trim(trim_citys_province(str1.downcase,citys,province))
  	s2 = trim(trim_citys_province(str2.downcase,citys,province))
    s1 = trim_type(s1,shop1["t"])
    s2 = trim_type(s2,shop2["t"])
    #puts "#{s1} - #{s2}"   if $0=="script/rails"
    fac1 = str_similar(s1,s2)
    fac2 = str_similar(s1[0,2],s2[0,2])
    fac3 = (fac2==0) ? 0.1 : 0
    return 0.8*fac1 + 0.2*fac2 - fac3
  end
  
  def addr_similar(str1,str2,citys,province,shop1,shop2)
    return 0.3 if(str1.nil? || str1=="" || str2.nil? || str2=="") 
  	s1 = trim(trim_citys_province(str1.downcase,citys,province))
  	s2 = trim(trim_citys_province(str2.downcase,citys,province))
    x1 = s1.split(" ")
    x2 = s2.split(" ")
    return 0.3 if (x1.length==0 || x2.length==0)
    s1=x1[x1.length-1]
    s2=x2[x2.length-1]
    #puts "#{s1} - #{s2}"
    ret = str_similar(s1,s2)
    factor = s1[-2..-1]==s2[-2..-1]? 0.05 : -0.25
    return ret+factor
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
  
  def dist_score(d)
    if d < 1000
      10-Math.log(d+1, 1.8)
    else
      -2 + -4*((d-1000)/1000.0)
    end
  end
  
  def similarity(shop1,shop2)
    return 0 if shop1["shops"] && shop1["shops"].index(shop2["_id"])
    return 0 if shop2["shops"] && shop2["shops"].index(shop1["_id"])
    citys = []
    province = nil
    City.where({code:shop1["city"]}).each do |x| 
      province = x.s
      citys << x.name
    end
    name_score = 65*name_similar(shop1["name"],shop2["name"],citys,province,shop1,shop2) + 5*str_similar(shop1["name"],shop2["name"])
    addr_score = 12*addr_similar(shop1.addr,shop2.addr,citys,province,shop1,shop2)
    type_score = 4*(shop1["t"]==shop2["t"]? 1:0) + 4*(shop1["type"]==shop2["type"]? 1:0)
    #puts "distance: #{distance(shop1,shop2)}"  if $0=="script/rails"
    dist_score = dist_score(distance(shop1,shop2))
    #puts [name_score,addr_score,type_score,dist_score] if $0=="script/rails"
    return name_score+addr_score+type_score+dist_score
  end

  def similarity_by_id(id1,id2)
    return similarity(Shop.find(id1),Shop.find(id2))
  end
  
  def similar_shops(x, min_score=60)
    sames =[]
    Shop.where({lo:{"$within" => {"$center" => [x.loc_first_of(x),0.003]}}} ).each do |y|
      next if y.id==x.id
      begin
        score = Shop.similarity(x,y)
      rescue
        next
      end
      sames << [y,score] if score>min_score
    end
    sames.each {|x| puts x}
    sames.sort{|a,b| b[1]<=>a[1]}.map{|x| x[0]}
  end
  
end
