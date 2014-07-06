# coding: utf-8
#用户设备

class PhotoDayStat
  include Mongoid::Document
  field :_id, type: String
  field :wb, type: Integer
  field :qq, type: Integer
  field :total, type: Integer
  field :pic, type: Integer
  field :album, type: Integer
  field :shops, type:Array

end
