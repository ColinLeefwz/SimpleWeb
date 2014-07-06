# coding: utf-8

class Channel
  include Mongoid::Document
  field :ip
  field :time
  field :agent
  field :v

end

