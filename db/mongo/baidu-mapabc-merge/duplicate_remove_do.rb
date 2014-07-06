
SinaUser.collection.database.session[:tmp].find.each do |x|
  begin
  arr = [[x["_id"],x["type"]]]
  x["sames"].each do |y|
    arr << [y["_id"],y["type"]]
  end
  arr.sort! {|a,b| b[1].length <=> a[1].length }
  if arr[0][1].split(";")[0] == arr[1][1].split(";")[0]
    begin
      arr[1..-1].each {|a| Shop.find(a[0].to_i).delete}
	rescue
	end
  	SinaUser.collection.database.session[:tmp].find({_id:x["_id"].to_i}).remove_all
  end
  rescue
  end
end