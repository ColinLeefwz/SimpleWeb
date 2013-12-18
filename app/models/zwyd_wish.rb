# coding: utf-8

class ZwydWish
  include Mongoid::Document
  field :_id,  type: Moped::BSON::ObjectId
  field :total, type: Integer
  field :data, type: Array #[[大名， 祝福]，[大名， 祝福]...]

  def photo
  	Photo.find_by_id(_id)
  end

end