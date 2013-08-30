# coding: utf-8

class SimilarShop
  include Mongoid::Document
  field :city   #城市
  field :data, type: Array #[{id: '地点id', name: '地点名称', dis: "和第一个地点的距离", type: "处理结果"}]
  field :flag, type: Boolean  #处理方式是否完成
  

  #初始化城市相似的商家
  def self.init(city, simv=55)
    Shop.where({city: city, t:{"$exists" => true}, _id:{"$gt" => 1202842}}).sort({_id:1}).each do |shop|
      begin
        ss = Shop.similar_shops(shop,simv)
        if ss.size>0
          flag = ss.find{|x| x.id<shop.id}
          next if flag
          data = [{id: shop.id, name: shop.name}]
          ss.each {|x|  data << {id: x.id, name: x.name, dis: Shop.new.get_distance(x.loc_first, shop.loc_first) }}
          self.create(city: city, data: data)
        end
      rescue
        next
      end
    end
  end
end
