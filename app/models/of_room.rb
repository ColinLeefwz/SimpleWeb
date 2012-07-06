class OfRoom < ActiveRecord::Base
  include Openfire
  self.table_name = "ofMucRoom"
  self.primary_key = "name"
  
  def self.gen_from_shop(mshop)
    unless OfRoom.find_by_name(mshop.id)
      gen_from_shop0 mshop
      return true
    else
      return false
    end
  end

  def self.gen_from_shop!(mshop)
    raise "shop #{mshop.id} is already exsits." if OfRoom.find_by_name(mshop.id)
    gen_from_shop0 mshop
  end
  
  def self.gen_from_shop0(mshop)
    room = OfRoom.find_by_serviceID_and_roomID(1,99999999).dup
    room.name = mshop.id
    room.naturalName = mshop.name
    room.roomID = mshop.id
    room.subject = ""
    room.save!
  end
    
  def self.sync
    Mshop.all.each_with_index {|shop,i| OfRoom.gen_from_shop(shop);i}
  end
  
end
