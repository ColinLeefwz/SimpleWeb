# coding: utf-8
# 旅行团
class Group
  include Mongoid::Document
  field :name #名称 ， 默认为"线路名称＋团号"
  field :code #团号
  field :line_id, type: Moped::BSON::ObjectId #所属线路
  field :admin_sid, type:Integer #所属旅行社
  field :fat, type: Date  #开始时间
  field :tat, type: Date #结束时间
  field :users, type:Array #团员 [ { name:姓名, phone:手机, sfz:身份证, id:用户id } ]
  field :hint #加入此团的认证提示信息

  with_options :prefix => true, :allow_nil => true do |option|
    option.delegate :name,  :to => :line
  end
  
  after_create :gen_shop

  def gen_shop
    s = Shop.new
  	s.id = Shop.next_id
  	s.name = name
  	s.psid = admin_sid
    s.group_id = self.id
    s.save
  end

  def line
    Line.find_by_id(line_id)
  end


  def show_users(link=true)
    str =""
    users.each do|u|
      str += "#{u['name']},#{u['phone']},#{u['sfz']}"
      if link
        str += ",<a href='/shop_checkins/user?uid=#{u['id']}' style='color: #0B99D7'>#{u['id']}</a>" if u['id']
        str += "<br/>"
      else
        str += ",#{u['id']}"  if u['id']
        str += '\r\n'
      end
    end
    str
  end

  def show_hint
    ['请输入电话号码', '请输入身份证号码'][hint.to_i]
  end
  
end

