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
	  Baidu.collection.find({lo:{"$near" => x["lo"], "$maxDistance" => 0.001 }, type:/^购物;(超市|综合商场|电器商场)/}).each do |bd|
	  	return bd if similar(x["name"],bd["name"])
	  end
	  return nil
end

Mapabc.collection.find({type:/^购物服务;商场/,bid:{"$exists" => false}}).sort({_id:1}).each do |x|
	begin
	  bd = has_similar(x)
    if bd.nil?
      Shop.collection.database.session[:tmp_shoping].insert(x) 
    else
	    x["bid"] = bd["_id"]
	    Mapabc.collection.database.session[:tmp_shoping_equal].insert(x)  
    end
	rescue Exception =>e
		puts x.to_yaml
		puts e
	end
end


