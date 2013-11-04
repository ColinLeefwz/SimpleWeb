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


  #db.gchats.ensureIndex({mid:1},{unique:true})

  def self.insert_to_mongo(chat,sid)
    begin
      text = chat[1].strip
      return nil if text.match(/(^0[1-9]?$)|(@@@)|(###)/)
      gchat = Gchat.new(uid: chat[0], sid: sid, mid: chat[3], txt: chat[1])
      gchat._id = (chat[2].to_s(16)+ '0'*10 +(0..9).to_a.sample(6).join('')).__mongoize_object_id__
      gchat.save!
      return true
    rescue
      nil
    end
  end

  def self.remain_init_to_mongo(sid,skip, count)
    begin
      chats = JSON.parse(Xmpp.get("api/gchat2?room=#{sid}&skip=#{skip}&count=#{count}"))
      chats.each{|chat|  insert_to_mongo(chat, shop.id)}
      remain_init_to_mongo(sid,skip+count, count)
    rescue
      return nil
    end
  end


  def self.init_to_mongo(initsid=0)
    #    sids = Checkin.distinct(:sid).select{|m| m > initsid}
    sids = [21828775, 21835801, 21835409]
    Shop.where(_id: {'$in' => sids}).sort({_id: 1}).each do |shop|
      begin
        chats = JSON.parse(Xmpp.get("api/gchat2?room=#{shop.id}&skip=0&count=50"))
        chats.each{|chat| insert_to_mongo(chat, shop.id) }
        remain_init_to_mongo(shop.id,50, 50) if chats.length ==50
      rescue
        next
      end
    end
  end

end

