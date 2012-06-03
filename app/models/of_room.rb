class OfRoom < ActiveRecord::Base
  include Openfire
  self.table_name = "ofMucRoom"
  self.primary_key = "name"
  
  def self.gen_from_shop(mshop)
    raise "shop #{mshop.id} is already exsits." if OfRoom.find_by_name(mshop.id)
    room = OfRoom.order(:roomID).last.dup
    room.name = mshop.id
    room.naturalName = mshop.name
    room.roomID += 1
    room.save!
  end
  
end
