# coding: utf-8
#用户设备

class UserDeviceStat
  include Mongoid::Document
  field :_id, type: String
  field :cios, type: Integer
  field :card, type: Integer

  field :ios, type: Hash
  field :ard, type: Hash


end
