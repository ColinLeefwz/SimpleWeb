# coding: utf-8

class GpsLog
  include Mongoid::Document
  field :uid
  field :lo
  field :acc
  field :bssid
  field :bd

end

