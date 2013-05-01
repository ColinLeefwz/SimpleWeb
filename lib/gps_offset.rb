
module GpsOffset

  def get_lo_offset(lo)
    hash = "OF%.2f%.1f" %  lo
    field = ("%.2f" %  lo[1])[-1..-1]
    str = $redis.hget(hash,field)
    return [0,0] if str.nil?
    str.split(",").map{|x| x.to_f}
  end
  
  def get_lo_offset_riak(lo)
    #return [0,0] if ENV["RAILS_ENV"] != "production"
    begin
      client = Ripple.client
      bucket = client.bucket('boffsets')
      k = "%.2f%.2f" %  lo
      data = bucket.get(k).data
      return data
    rescue Exception => e
      logger.warn e
      offset = Mongoid.session(:dooo)[:offsetbaidus].where({loc: {'$near' => lo}}).first
      return offset['d'] if offset
      return [0,0]
    end
  end

  def lob_to_lo(lob)
    data = get_lo_offset(lob)
    [lob[0]-data[0],lob[1]-data[1]]
  end

  def lob_to_lo_mongo_1dooo(lob)
    tmp = Mongoid.session(:dooo)[:offsetbaidus].where({loc: {'$near' => lob}}).first
    [lob[0]-tmp['d'][0],lob[1]-tmp['d'][1]];
  end
  
  def lo_to_lob(lo)
    data = get_lo_offset(lo)
    [lo[0]+data[0],lo[1]+data[1]]
  end

  
end
