class HeatLoc
  include Mongoid::Document
  store_in(:session => "dooo")

  def self.cpoi(token)
    HeatLoc.where({:c => {'$gt' => 100}, :cnum => {"$exists" => false}}).sort({:c => -1}).to_a.each do |heat_loc|
      heat_loc.poi(token)
    end
  end

  def poi(token)
    SinaPoi.pois_insert(token,self.lo)
  end
  
end
