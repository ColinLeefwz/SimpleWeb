class HeatLoc
  include Mongoid::Document
  store_in(:session => "dooo")

  def self.start
    HeatLoc.cpoi('2.00t9e5PCHkEBGB6181606c3c0b8iY1')
  end

  def self.cpoi(token)
    HeatLoc.where({:c => {'$gt' => 100}, :fetched => {"$exists" => false}}).sort({:c => -1}).to_a.each do |heat_loc|
      heat_loc.poi(token)
    end
  end

  def poi(token)
    SinaPoi.pois_insert(token,self.lo)
    self.update_attribute(:fetched, true )
  end
  
end
