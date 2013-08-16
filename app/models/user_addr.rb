# coding: utf-8
#通讯录
class UserAddr
  include Mongoid::Document
  field :phone
  field :list, type:Array #通讯录
  
    
end
