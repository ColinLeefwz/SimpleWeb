# coding: utf-8

class Gchat
  include Mongoid::Document
  field :sid, type: Integer #商家id
  field :uid,  type: Moped::BSON::ObjectId
  field :mid
  field :txt

  
  def user
    User.find_by_id(self.uid)
  end
  
  def shop
    Shop.find_by_id(self.sid)
  end
  
  def self.history_skip(sid,skip,pcount)
    arr = Gchat.where({sid:sid}).sort({_id:-1}).skip(skip).limit(pcount).to_a
    rmd= $redis.smembers("RoomMsgDel#{sid}")
    arr.reject!{|x| rmd.include?(x.txt)}
    if skip==0
      cpid = Shop.find_by_id(sid).card_photo.id.to_s
      arr.delete_if{|x| x.txt[0,5] == "[img:" && x.txt[5,24] == cpid}
    end
    arr
  end
  
  def self.history(sid,pcount,mid=nil)
    hash = {sid:sid}
    if mid
      gchat = Gchat.where({mid:mid}).first
      hash.merge!({_id: {"$lt" => gchat.id} })
    end
    arr = Gchat.where(hash).sort({_id:-1}).limit(pcount).to_a
    rmd= $redis.smembers("RoomMsgDel#{sid}")
    arr.reject!{|x| rmd.include?(x.txt)}
    if mid.nil?
      cpid = Shop.find_by_id(sid).card_photo.id.to_s
      arr.delete_if{|x| x.txt[0,5] == "[img:" && x.txt[5,24] == cpid}
    end
    arr
  end


  #db.gchats.ensureIndex({mid:1},{unique:true})

  def self.insert_to_mongo(chat,sid)
    begin
      text = chat[1].strip
      return nil if text.match(/(^0[1-9]?$)|(@@@)|(###)/)
      gchat = Gchat.new(uid: chat[0], sid: sid, mid: chat[3], txt: chat[1])
      gchat._id = (chat[2].to_s(16)+ '0'*10 +(0..9).to_a.sample(6).join('')).__mongoize_object_id__
      gchat.save
    rescue
      nil
    end
  end

  def self.remain_init_to_mongo(shop,skip, count)
    begin
      chats =shop.history(skip,count) 
      chats.each{|chat|  insert_to_mongo(chat, shop.id)}
      remain_init_to_mongo(shop,skip+count, count) if chats.count == count
    rescue
      return nil
    end
  end


  def self.init_to_mongo(initsid=0)
    #    sids = [21828775, 21835801, 21835409]
    File.open("/mnt/lianlian/log/gchat_init_to_mongo.log", 'w+') do |f|
      Checkin.distinct(:sid).sort.select{|m| m > initsid}.each do |id|
        begin
          shop = Shop.find_by_id(id)
          next if shop.nil?
          f.puts shop.id
          chats = shop.history(0,50)
          next if chats.blank?
          chats.each{|chat| insert_to_mongo(chat, shop.id) }
          remain_init_to_mongo(shop,50, 50) if chats.length ==50
        rescue
          next
        end
      end
    end
  end

  def self.init_to_mongo2
    File.open("/mnt/lianlian/log/gchat_init_to_mongo.log", 'w+') do |f|
      $redis.keys("UA*").each do |ua|
        begin
          cman = $redis.zcard(ua)
          sid = ua.gsub(/UA/,'' )
          if Gchat.history_skip(sid, 0, cman).size <  cman
            shop = Shop.find_by_id(sid)
            next if shop.nil?
            chats = shop.history(0,50)
            next if chats.blank?
            chats.each{|chat| insert_to_mongo(chat, shop.id) }
            remain_init_to_mongo(shop,50, 50) if chats.length ==50
          end
        rescue
          next
        end
      end
    end
  end

end
