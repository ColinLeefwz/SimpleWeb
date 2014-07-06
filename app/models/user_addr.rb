# coding: utf-8
#通讯录
class UserAddr
  include Mongoid::Document
  field :phone
  field :mac
  field :list, type:Array #通讯录

  index({list: 1})

  include PhoneUtil


  def self.find_or_new(id)
    ua = find_by_id(id)
    return ua if ua
    ua = self.new
    ua.id = id
    return ua
  end
  
  def self.normalize
    UserAddr.all.each do |ua|
      list = ua.list.map{|x| x["number"] = phone_normalize(x["number"]); x}
      ua.set(:list, list)
    end
    UserAddr.all.each do |ua|
      list = ua.list
      list.delete_if {|x| x["number"]==nil || x["number"].size<11}
      list.delete_if {|x| x["name"]==nil }
      ua.set(:list, list) if list.size < ua.list.size
    end
  end
    

    
end
