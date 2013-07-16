# coding: utf-8

class PhotoShare
  include Mongoid::Document
  field :uid, type: Moped::BSON::ObjectId
  field :pid

end

