# encoding: utf-8
require 'user'
class CheckWbToken
  @queue = :normal

  def self.perform(wb_uid, token)
    info = RestClient.get "https://api.weibo.com/2/account/get_uid.json?source=#{$sina_api_key}&access_token=#{token}"
    #{"uid": 2059786127}
    raise "微博#{wb_uid},#{token}认证失败" unless info.index(wb_uid)
  end
  
end