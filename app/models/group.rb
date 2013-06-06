# coding: utf-8
# 旅行团
class Group
  include Mongoid::Document
  field :name #名称 ， 默认为"线路名称＋团号"
  field :code #团号
  field :line_id, type: Moped::BSON::ObjectId #所属线路
  field :admin_sid, type:Integer #所属旅行社
  field :fat, type: DateTime  #开始时间
  field :tat, type: DateTime #结束时间
  field :users, type:Array #团员 [ { name:姓名, phone:手机, sfz:身份证, id:用户id } ]
  field :hint #加入此团的认证提示信息
  
  def gen_shop
    s = Shop.new
  	s.id = Shop.next_id
  	s.name = name
  	s.psid = admin_sid
    s.group_id = self.id
    s.save
  end
  
end

