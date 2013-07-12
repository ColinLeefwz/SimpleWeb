# coding: utf-8

class GpsLog
  include Mongoid::Document
  field :uid,  type: Moped::BSON::ObjectId
  field :lo
  field :acc   #误差
  field :bssid
  field :bd    #是否百度定位
  field :speed #速度
  field :wifi, type: Array
  field :gps, type: Hash
  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name, :to => :user
  end
  def user
    @user ||= User.find_by_id(uid)
  end

end

