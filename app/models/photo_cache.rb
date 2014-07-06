class PhotoCache

  def shop_photo_cache_key(sid,skip,pcount)
    "SP#{sid}-#{pcount}"
  end
  
  def shop_photo_cache(sid,skip,pcount)
    if skip>0
      return shop_photo_no_cache(sid,skip,pcount)
    end
    Rails.cache.fetch(shop_photo_cache_key(sid,skip,pcount)) do
      shop_photo_no_cache(sid,skip,pcount)
    end
  end
  
  def shop_photo_no_cache(sid,skip,pcount)
    if sid.to_i == 21834120
      Photo.where({room:sid.to_s, hide: nil, user_id: "s21834120"}).sort({od: -1, updated_at: -1}).skip(skip).limit(pcount).to_a
    else
    Photo.where({room:sid.to_s, hide: nil}).sort({od: -1, updated_at: -1}).skip(skip).limit(pcount).to_a
    end
  end
  
  def del_shop_photo_cache(sid,skip,pcount)
    Rails.cache.delete(shop_photo_cache_key(sid,skip,pcount))
  end
  
  
  
  def user_photo_cache_key(uid,skip,pcount)
    "UP#{uid}-#{pcount}"
  end
  
  def user_photo_cache(uid,skip,pcount)
    if skip>0
      return user_photo_no_cache(uid,skip,pcount)
    end
    Rails.cache.fetch(user_photo_cache_key(uid,skip,pcount)) do
      user_photo_no_cache(uid,skip,pcount)
    end
  end
  
  def user_photo_no_cache(uid,skip,pcount)
    arr = $redis.smembers("UnBroadcast")
    arr.push(nil)
    arr.push("")
    Photo.where({user_id: uid, room:{"$nin" => arr} }).
      sort({updated_at: -1}).skip(skip).limit(pcount).to_a
  end
  
  def del_user_photo_cache(sid,skip,pcount)
    Rails.cache.delete(user_photo_cache_key(sid,skip,pcount))
  end
  
  

end
