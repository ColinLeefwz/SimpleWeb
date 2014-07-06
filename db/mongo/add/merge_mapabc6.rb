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
  m1 = (a3.size*1.0/a1.size)
  m2 = (a3.size*1.0/a2.size)
  return false if m1<0.5
  return false if m2<0.5  
  factor = (s1.length+s2.length)/100.0
  return false if m1+m2<(1.4-factor)
  return true
end

def has_similar(x)
	  Baidu.collection.find({lo:{"$near" => x["lo"], "$maxDistance" => 0.001 }, type:/^餐饮/}).each do |bd|
	  	return bd if similar(x["name"],bd["name"])
	  end
	  return nil
end

begin
Shop.collection.database.session[:tmp_hotel].find({"_id" => { "$gt" => 9161976}}).sort({_id:1}).each do |x|
	begin
	  name = x["name"]
	  type = x["type"]
	  bd = has_similar(x)
    unless bd.nil?
x["bid"] = bd["_id"]
	    Mapabc.collection.database.session[:tmp_hotel2].insert(x)      
Shop.collection.database.session[:tmp_hotel2].insert(x)
    end
	rescue Exception =>e
		puts x.to_yaml
		puts e
	end
end
rescue Exception =>e2
	puts e2
	puts e2.backtrace
end
