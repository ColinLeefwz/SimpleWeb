# coding: utf-8

require 'csv'

def row(csv,x)
	csv << [x["_id"].to_i, x["name"], x["city"], x["addr"], x["type"], x["lo"]  ]
end

CSV.open("same_hz.csv", "wb") do |csv|
  csv << ["id", "名称", "城市", "地址", "类型", "经纬度"]
  User.collection.database.session[:tmp].find({city:"0571"}).each do |x|
  	row(csv,x)
    x["sames"].each do |y|
      row(csv,y)
    end
  end
end