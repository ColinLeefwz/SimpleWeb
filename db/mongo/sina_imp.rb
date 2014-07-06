#db.sina_pois.findOne({city:"0571",shop_id:{$exists:true}}).title
#db.sina_pois.count({city:"0571",shop_id:{$exists:true}})

Mapabc.collection.database.session[:sina_pois].find({city:"0571",shop_id:{"$exists" => true}}).sort({"_id" => 1}).each do |x|
  begin
    datas = x["datas"]
    next if datas.nil?
    puts "#{x['title']} : #{datas.length}"
    hash = {_id: x["shop_id"]}
    users = []
    datas.each do |data|
      uid,txt,from,time = data
      next unless from.match(/iphone|ipad/i)
      su = SinaUser.find_by_id(uid)
      if su
      	user = su.convert_to_user 
      	users << user._id
      end
    end
    if users.length >0
    	hash["users"] = users
      Shop.collection.database.session[:shop_sina_users].insert(hash)
    end
  rescue Exception => e
	puts e
  	puts e.backtrace
	puts "\n\n"
  end
end



