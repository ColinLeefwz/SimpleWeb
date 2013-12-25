# coding: utf-8

class ChannelDesc
  include Mongoid::Document
  field :num
  field :who
  field :where
  field :type, type: Boolean, default: false

end

