# encoding: utf-8
#对应商家

$Logger = Logger.new('log/weibo/correspond_shop.log', 0, 100 * 1024 * 1024)
class CorrespondShop

  def self.preform
    SinaPoi.where({shop_id: {'$exists' => false}}).sort({_id: 1}).each do |poi|
      info = "poi_id: #{poi._id};"
      re = SinaPoi.check(poi.title, poi.lo)

      if re
        info += "对应：#{re};"
        poi.update_attributes(re)
        if poi.respond_to?(:shop_id) && poi.respond_to?(:baidu_id)
          info += "取消百度:#{poi.baidu_id}"
          poi.unset(:baidu_id)
        end
      end
      $Logger.info(info)
    end
  end
end

CorrespondShop.preform