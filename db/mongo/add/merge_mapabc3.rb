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
	  Baidu.collection.find({lo:{"$near" => x["lo"], "$maxDistance" => 0.001 }, type:/^宾馆/}).each do |bd|
	  	return bd if similar(x["name"],bd["name"])
	  end
	  return nil
end

Shop.collection.database.session[:tmp3].find().sort({_id:1}).each do |x|
	begin
	  bd = has_similar(x)
    unless bd.nil?
	  x["bid"] = bd["_id"]
	    Shop.collection.database.session[:tmp34].insert(x)  
    end
	rescue Exception =>e
		puts x.to_yaml
		puts e
	end
end


