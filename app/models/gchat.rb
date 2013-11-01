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
  def self.init_to_mongo
#    sids = Checkin.distinct(:sid)
      sids = [21828775]
    Shop.where(_id: {'$in' => sids}).sort({_id: 1}).each do |shop|
        JSON.parse(Xmpp.get("api/gchat?room=#{shop.id}")).each do |chat|
          begin
            text = chat[1].strip
            if text.match(/(^0[1-9]?$)|(@@@)|(###)/)
              next
            end
            gchat = Gchat.new(uid: chat[0], sid: shop.id, mid: chat[3], txt: chat[1])
            gchat._id = (chat[2].to_s(16)+ '0'*10 +(0..9).to_a.sample(6).join('')).__mongoize_object_id__
            gchat.save
          rescue
            next
          end
        end
    end
  end

end

