class HeatLoc
  include Mongoid::Document
  store_in(:session => "dooo")

  def self.start
    HeatLoc.cpoi($sina_token)
  end

  def self.cpoi(token)
    HeatLoc.where({:c => {'$gt' => 85}, :fetched => {"$exists" => false}}).sort({:c => -1}).to_a.each do |heat_loc|
      heat_loc.poi(token)
    end
  end

  def poi(token)
    SinaPoi.pois_insert(token,self.lo)
    self.update_attribute(:fetched, true )
  end
  
  def self.jiepang
    HeatLoc.where({:c => {'$gt' => 100}, :jp => {"$exists" => false}}).sort({:c => -1}).to_a.each do |heat_loc|
      datas = Jiepang.insert(heat_loc.lo)
      heat_loc.update_attribute(:jp, true ) unless datas.nil?
    end
  end
  
  
end
