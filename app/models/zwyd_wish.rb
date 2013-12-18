# coding: utf-8

class ZwydWish
  include Mongoid::Document
  field :_id,  type: Moped::BSON::ObjectId
  field :data, type: Hash #{total: 总数， wish: {'大名' => "祝福"}}

  def photo
  	Photo.find_by_id(_id)
  end

end