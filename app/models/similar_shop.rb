# coding: utf-8

class SimilarShop
  include Mongoid::Document
  field :city   #城市
  field :data, type: Array #[{id: '地点id', name: '地点名称', dis: "和第一个地点的距离", type: "处理结果"}]
  field :flag, type: Boolean  #处理方式是否完成 nil: 未处理， false: 暂不处理， true: 处理完成
  

  #初始化城市相似的商家
  #city是初始化某个城市， simv 是相似度
  def self.init(city, simv=55)
    Shop.where({city: city, t:{"$exists" => true}, _id:{"$gt" => 1202842}}).sort({_id:1}).each do |shop|
      produce(shop,simv)
    end
  end

  #继续初始化城市相似的商家， 继续上次中断时最后一个id开始
  def self.reinit(city, simv=55)
    lss = SimilarShop.where({city: city}).sort({"data.0.id"=> -1}).first
    stid = lss.data.first['id'].to_i
    Shop.where({city: city, t:{"$exists" => true}, _id:{"$gt" => stid}}).sort({_id: 1}).each  do |shop|
      produce(shop,simv)
    end

    #SimilarShop.where({data: {"$elemMatch"=>{"id" => 1207785}}})
  end


  def self.produce(shop,simv)
    puts "/#{shop.id}/"
    ss = Shop.similar_shops(shop,simv)
    return if ss.blank?
    flag = ss.find{|x| x.id<shop.id}
    return if flag
    data = [{id: shop.id, name: shop.name}]
    ss.each {|x|  data << {id: x.id, name: x.name, dis: Shop.new.get_distance(x.loc_first, shop.loc_first) }}
    self.create(city: shop.city, data: data)
  end


  def show_flag
    case flag
    when nil
      '未处理'
    when false
      "暂不处理"
    when true
      '处理完成'
    end
  end

end
