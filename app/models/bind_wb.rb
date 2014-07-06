# coding: utf-8
class BindWb
  include Mongoid::Document
  field :_id, type: Integer #商家id
  field :name #昵称
  field :login_name #登录名
  field :wb_uid, type: Integer #微博uid
  field :val, type:Boolean, default:false #是否验证过


  def check_wb
    return "微博登录名必填" if login_name.blank?
    return "微博uid必填" if wb_uid.blank?
    return "微博昵称必填" if name.blank?

    url = "https://api.weibo.com/2/users/show.json?access_token=2.00kfdvGCGFlsXC1b5e64ba39QaSfpB&uid=#{self.wb_uid}"
    begin
      response = JSON.parse(RestClient.get(url))
      return '微博uid和微博昵称不匹配'  if response["screen_name"] != self.name
      self.val = true
    rescue RestClient::BadRequest
      return  '微博uid可能不存在'
    rescue
    end
    return nil
  end
  
  def shop
    Shop.find(self._id)
  end

  def weibo_home
    "http://www.weibo.com/#{wb_uid}" if wb_uid
  end
  
  # 根据商家id获得其企业微博的名字，或者是主店的企业微博的名字
  def self.wb_name(sid)
    bindwb = BindWb.find_by_id(sid)
    return bindwb.name if bindwb
    psid = Shop.find_by_id(sid).try(:psid)
    return BindWb.find_by_id(psid).try(:name)
  end

end
