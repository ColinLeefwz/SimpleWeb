# encoding: utf-8
module AdminSinaPoisHelper
  def link_correspond_shop(poi)
    if poi.respond_to?(:shop_id)
      shop = Shop.find(poi.shop_id)
      link_to "S:#{shop.name.try(:name)}", "/admin_shops/show?id=#{poi.shop_id}"
    elsif poi.respond_to?(:baidu_id)
      baidu = Baidu.find(poi.baidu_id)
      link_to "B:#{baidu.name.try(:name)}", "/admin_baidu?id=#{poi.baidu_id}"
    end
  end

  def dt_selector
    arr = []
    SinaCategorys::SUPCATEGORY.each_with_index { |c,i|  arr << [c,i] }
    arr
  end
end