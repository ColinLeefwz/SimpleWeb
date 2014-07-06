# encoding: utf-8
module AdminSinaPoisHelper
  def link_correspond_shop(poi)
    if poi.respond_to?(:shop_id)
      shop = Shop.find_by_id(poi.shop_id)
      link_to "S:#{shop.name}", "/admin_shops/show?id=#{poi.shop_id}" if shop
    elsif poi.respond_to?(:baidu_id)
      baidu = Baidu.find_by_id(poi.baidu_id)
      link_to "B:#{baidu.name}", "/admin_baidu?id=#{poi.baidu_id}" if baidu
    end
  end

  def dt_selector
    arr = []
    SinaCategorys::SUPCATEGORY.each_with_index { |c,i|  arr << [c,i] }
    arr
  end
end