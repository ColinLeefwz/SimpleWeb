def trim(str)
	str.sub!(/\./,"")
	str.sub!(/\(/,"")
	str.sub!(/\)/,"")
	str.sub!(/（/,"")
	str.sub!(/）/,"")	
	str
end

def similar(str1,str2)
	s1 = trim(str1)
	s2 = trim(str2)
	a1 = s1.split(//).to_set
	a2 = s2.split(//).to_set
  a3 = a1 & a2
  return false if (a3.size*1.0/a1.size)<0.65
  return false if (a3.size*1.0/a2.size)<0.65  
  return true
end

def has_similar(x)
	  Baidu.collection.find({lo:{"$near" => x["lo"], "$maxDistance" => 0.001 }, type:/^餐饮/}).each do |bd|
	  	return bd if similar(x["name"],bd["name"])
	  end
	  return nil
end

Mapabc.collection.find({type:/^餐饮/, bid:{"$exists" => false}}).sort({_id:1}).each do |x|
	begin
	  name = x["name"]
	  type = x["type"]
	  next if type.index("餐饮服务;休闲餐")                   
		next if type.index("餐饮服务;冷饮店")
		next if type.index("餐饮服务;咖啡厅")
		next if type.index("餐饮服务;甜品店")
		next if type.index("餐饮服务;糕饼店")
		next if type.index("餐饮服务;茶艺馆")
	  next if name =~ /公司/
	  next if name.length>16
	  bd = has_similar(x)
    if bd.nil?
	    Shop.collection.database.session[:tmp3].insert(x)
    else
      x["bid"] = bd["_id"]
	    Mapabc.collection.database.session[:mapabc_baidu_name_similar].insert(x)      
    end
	rescue Exception =>e
		puts x.to_yaml
		puts e
	end
end

