
def shops_out_xls(city_id)
  city = Mcity.find_by_id(city_id)
  shops = Mshop.where(["mcity_id = ?",city_id])
  File.open("#{Rails.root}/hangzhou.csv", "w+") do |f|
    f.puts ['序号', '城市', '分类', '区域', '总点评数', '商家名称','地址','电话','联系人', '经度', '纬度'].join(';')
    shops.each do |shop|
      f.puts [shop.id, shop.mcity.name, shop.mcategory_join_name, shop.mdistrict_join_name, shop.comment_count, shop.name, shop.address, shop.phone, shop.linkman, shop.lng.to_s.ljust(11,'0'), shop.lat.to_s.ljust(10,'0')].join(';')
    end
  end

 
end


shops_out_xls(3)