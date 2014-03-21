
module GpsOffset

  def get_baidu_offset(lo)
    return nil unless lo
    hash = "OF%.2f%.1f" %  lo
    field = ("%.2f" %  lo[1])[-1..-1]
    str = $redis.hget(hash,field)
    if str.nil?
      Xmpp.error_notify("百度纠偏数据没有:#{lo}")
      ofs = $redis.hgetall(hash)
      return [0,0] if ofs.nil? || ofs.size==0
      down = (field.to_i-1)%10
      downv = ofs[down.to_s]
      up = (field.to_i+1)%10
      upv = ofs[up.to_s]
      if downv && upv
        dvv = downv.split(",").map{|x| x.to_f}
        upvv = upv.split(",").map{|x| x.to_f}
        ret = [(dvv[0]+upvv[0])/2, (dvv[1]+upvv[1])/2]
        $redis.hset(hash,field,ret.join(","))
        return ret
      end
      if downv
        $redis.hset(hash,field,downv)
        return downv.split(",").map{|x| x.to_f}
      end
      if upv
        $redis.hset(hash,field,upv)
        return upv.split(",").map{|x| x.to_f}
      end
      ret = ofs.first[1]
      $redis.hset(hash,field,ret)
      return ret.split(",").map{|x| x.to_f}
    end
    str.split(",").map{|x| x.to_f}
  end

  def lob_to_lo(lob)
    data = get_baidu_offset(lob)
    [lob[0]-data[0],lob[1]-data[1]]
  end

  def lob_to_lo_mongo_1dooo(lob)
    tmp = Mongoid.session(:dooo)[:offsetbaidus].where({loc: {'$near' => lob}}).first
    [lob[0]-tmp['d'][0],lob[1]-tmp['d'][1]];
  end
  
  def lo_to_lob(lo)
    data = get_baidu_offset(lo)
    [lo[0]+data[0],lo[1]+data[1]]
  end
  
  def get_gcj_offset(lo)
    return nil unless lo
    hash = "GCJ%.2f%.1f" %  lo
    field = ("%.2f" %  lo[1])[-1..-1]
    str = $redis.hget(hash,field)
    if str.nil?
      Xmpp.error_notify("GCJ纠偏数据没有:#{lo}")
      ofs = $redis.hgetall(hash)
      return [0,0] if ofs.nil? || ofs.size==0
      down = (field.to_i-1)%10
      downv = ofs[down.to_s]
      up = (field.to_i+1)%10
      upv = ofs[up.to_s]
      if downv && upv
        dvv = downv.split(",").map{|x| x.to_f}
        upvv = upv.split(",").map{|x| x.to_f}
        ret = [(dvv[0]+upvv[0])/2, (dvv[1]+upvv[1])/2]
        $redis.hset(hash,field,ret.join(","))
        return ret
      end
      if downv
        $redis.hset(hash,field,downv)
        return downv.split(",").map{|x| x.to_f}
      end
      if upv
        $redis.hset(hash,field,upv)
        return upv.split(",").map{|x| x.to_f}
      end
      ret = ofs.first[1]
      $redis.hset(hash,field,ret)
      return ret.split(",").map{|x| x.to_f}
    end
    str.split(",").map{|x| x.to_f}
  end
  
  def log_to_lo(log)
    data = get_gcj_offset(log)
    [log[0]-data[0],log[1]-data[1]]
  end
  
  def lo_to_log(lo)
    data = get_gcj_offset(lo)
    [lo[0]+data[0],lo[1]+data[1]]
  end
  

  
end
