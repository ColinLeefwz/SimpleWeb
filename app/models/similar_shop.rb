# coding: utf-8

class SimilarShop
  include Mongoid::Document
  field :city   #城市
  field :data, type: Array #[{id: '地点id', name: '地点名称', dis: "和第一个地点的距离", type: "处理结果"}]
  field :flag, type: Boolean  #处理方式是否完成 nil: 未处理， false: 暂不处理， true: 处理完成
  

  #初始化城市相似的商家
  #city是初始化某个城市， simv 是相似度
  def self.init(city, simv=55)
    Shop.where({city: city, t:{"$exists" => true}}).sort({_id:1}).each do |shop|
      produce(shop,simv)
    end
  end

  #继续初始化城市相似的商家， 继续上次中断时最后一个id开始
  def self.reinit(city, simv=55)
    lss = SimilarShop.where({city: city}).sort({"data.0.id"=> -1}).first
    if lss
      stid = lss.data.first['id'].to_i
    else
      stid= 0
    end
    Shop.where({city: city, t:{"$exists" => true}, _id:{"$gt" => stid}}).sort({_id: 1}).each  do |shop|
      produce(shop,simv)
      sleep(3)
    end

    #SimilarShop.where({data: {"$elemMatch"=>{"id" => 1207785}}})
  end

  def self.temp_init
   arr = ["0316", "0791", "0515", "0471", "0523", "0851",
     "0310", "0539", "0771", "0931", "0998", "0760", 
     "0752", "0514", "0537", "0754", "0317", "0511", 
     "0472", "0432", "0533", "0379", "0756", "0518", 
     "0912", "0517", "0412", "0553", "0527", "0631",
      "0477", "0910", "0357", "0546", "0816", "0898", 
      "0313", "0373", "0354", "0352", "0358", "0335", 
      "0359", "0372", "0750", "0319", "0459", "0370", 
      "0538", "0417", "0534", "0452", "0817", "0596",
       "0416", "0717", "0355", "0543", "0356", "0374", 
       "0476", "0716", "0951", "0852", "0530", "0710"]
     arr.each{|m| SimilarShop.reinit(m)}
  end


  def self.produce(shop,simv)
    puts "/#{shop.id}/"
    return if shop.lo.blank?
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
