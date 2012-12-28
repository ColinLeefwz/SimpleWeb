class Baidu
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

  def loc_first
    if self["lo"][0].class==Array
      self["lo"][0]
    else
      self["lo"]
    end
  end


  def num_to_rad(d)
    return d * 3.1416 / 180.0
  end

  def pow(x,y)
    x ** y
  end

  def get_distance4( lat1,  lng1,  lat2,  lng2)
    radLat1 = num_to_rad(lat1)
    radLat2 = num_to_rad(lat2)
    a = radLat1 - radLat2
    b = num_to_rad(lng1) - num_to_rad(lng2)
    s = 2 * Math.asin(Math.sqrt(pow(Math.sin(a/2),2) +
          Math.cos(radLat1)*Math.cos(radLat2)*pow(Math.sin(b/2),2)))
    s = s *6378.137  #EARTH_RADIUS;
    s = (s * 10000).round / 10
    return s
  end

  def get_distance( loc1,loc2)
    return get_distance4(loc1[0],loc1[1],loc2[0],loc2[1])
  end

  
  def self.find_by_id(id)
    begin
      self.find(id)
    rescue
      nil
    end
  end
end
