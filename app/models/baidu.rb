class Baidu
  include Gps
  include Mongoid::Document
  store_in({:collection =>  "baidu", :session => "dooo"})

  def self.match_sina
    SinaPoi.all.each do |sina_poi|
      b = SinaPoi.check_baidu(sina_poi.title, [sina_poi.lat.to_f, sina_poi.lon.to_f])
      if b
        sina_poi.update_attributes({"baidu_id" => b.first, 'mtype' => b.last})
      end
    end
  end
  
end
