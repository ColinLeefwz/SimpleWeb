
module Gps
  
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
  
  def min_distance(shop,loc)
    return 9999999 if shop["lo"].nil?
    if(shop["lo"][0].class==Array)
      shop["lo"].map {|x| get_distance(x,loc)}.min
    else
      return get_distance(shop["lo"],loc)
    end
  end
  
  def shop_distance(shop)
    min_distance(shop,loc_first)
  end
  
  def loc_first
    loc_first_of(self)
  end
  
  def loc_first_of(shop)
    return [] if shop["lo"].nil?
    if shop["lo"][0].class==Array
      shop["lo"][0]
    else
      shop["lo"]
    end
  end
    

  
  #经纬度合并
  def merge_locations(shops)
    if self["lo"][0].class==Array
      arr = self["lo"]
    else
      arr = [self["lo"]]
    end
    shops.each do |s|
      if s["lo"][0].class==Array
        arr << s["lo"][0]
      else
        arr << s["lo"]
      end
    end
    arr.uniq!
    arr
  end
  
  def merge_latlng(lat,lng)
    if self["lo"][0].class==Array
      arr = self["lo"]
    else
      arr = [self["lo"]]
    end
    arr << [lat,lng]
    arr.uniq!
    self.update_attributes!({lo:arr})
  end
  
  def mid_lo6(lat1,lng1,acc1,lat2,lng2,acc2)
    x = 1.0/acc1 + 1.0/acc2
    a1 = (1.0/acc1)/x
    a2 = (1.0/acc2)/x
    [lat1*a1+lat2*a2, lng1*a1+lng2*a2]
  end
  
  def mid_loc(lo1,acc1,lo2,acc2)
    mid_lo6(lo1[0],lo1[1],acc1,lo2[0],lo2[1],acc2)
  end

  
end
