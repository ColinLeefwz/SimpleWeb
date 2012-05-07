class Offset
  def self.offset(lat, lng)
    return [pixel2lat(lat2pixel(lat, 18) + 2 * 256 - 72 / 3, 18), pixel2lng(lng2pixel(lng, 18) + 4 * 256 - 2 * 72, 18)]
  end

  def self.antioffset(lat, lng)
    return [pixel2lat(lat2pixel(lat, 18) - (2 * 256 - 72 / 3), 18), pixel2lng(lng2pixel(lng, 18) - (4 * 256 - 2 * 72), 18)]
  end

  def self.lng2pixel(lng, zoom)
    return ((lng + 180) * (256 << zoom) / 360).to_f
  end

  def self.lat2pixel(lat, zoom)
    siny = Math.sin(lat * Math::PI / 180)
    y = Math.log((1 + siny) / (1 - siny))
    return ((128 << zoom) * (1 - y / (2 * Math::PI))).to_f
  end

  def self.pixel2lng(x, zoom)
    return (x * 360 / (256 << zoom) - 180).to_f
  end

  def self.pixel2lat(y, zoom)
    y = 2 * Math::PI * (1 - y / (128 << zoom))
    z = Math::E ** y
    siny = (z - 1) / (z + 1)
    return (Math.asin(siny) * 180 / Math::PI).to_f
  end

end
