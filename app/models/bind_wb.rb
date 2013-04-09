# coding: utf-8
class BindWb
  include Mongoid::Document
  field :_id, type: Integer #商家id
  field :name #昵称
  field :login_name #登录名
  field :wb_uid, type: Integer #微博uid
  field :val, type:Boolean, default:false #是否验证过

  validates_presence_of :wb_uid, :message => "微博uid必填."
  validates_presence_of :login_name, :message => "微博登录名必填."
  validates_presence_of :name, :message => "微博昵称必填."



  validate :check_wb
  def check_wb
    url = "https://api.weibo.com/2/users/show.json?access_token=#{$sina_token}&uid=#{self.wb_uid}"
    begin
      response = JSON.parse(RestClient.get(url))
      self.errors.add(:wu_uid, '微博uid和微博昵称不匹配.')  if response["screen_name"] != self.name
      self.val = true
    rescue RestClient::BadRequest
      self.errors.add(:wu_uid, '微博uid可能不存在.')
    rescue
    end
  end
  
  def shop
    Shop.find(self._id)
  end



  def self.find2(id)
    begin
      self.find(id)
    rescue
      nil
    end
  end
  
  # 根据商家id获得其企业微博的名字，或者是主店的企业微博的名字
  def self.wb_name(sid)
    bindwb = BindWb.find_by_id(sid)
    return bindwb.name if bindwb
    psid = Shop.find_by_id(sid).try(:psid)
    return BindWb.find_by_id(psid).try(:name)
  end

end
