# encoding: utf-8
require 'user'
class CheckWbToken
  @queue = :normal

  def self.perform(wb_uid, token)
    #info = RestClient.get "https://api.weibo.com/2/account/get_uid.json?source=#{$sina_api_key}&access_token=#{token}"
    #{"uid": 2059786127}
    info = RestClient.post "https://api.weibo.com/oauth2/get_token_info", :access_token => token
    #"{\"uid\":1882778962,\"appkey\":\"2054816412\",\"scope\":null,\"create_at\":1367805567,\"expire_in\":-737108}" 
    unless info.index(wb_uid)
      Xmpp.error_notify("微博#{wb_uid},#{token}认证失败")
      raise "微博#{wb_uid},#{token}认证失败" 
    end
    if ActiveSupport::JSON.decode(info)["expire_in"]<0
      Rails.logger.error("WB_Expire:#{wb_uid},#{token}")
      user = User.find_by_wb(wb_uid)
      Rails.logger.error("WB_Expire-:#{user.name},#{user.cat}")      
    end
  end
  
end