# coding: utf-8
#通讯录
class UserAddr
  include Mongoid::Document
  field :phone
  field :list, type:Array #通讯录



  def self.find_or_new(id)
    ua = find_by_id(id)
    return ua if ua
    ua = self.new
    ua.id = id
    return ua
  end
    
end
