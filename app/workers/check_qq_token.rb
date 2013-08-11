# encoding: utf-8
require 'user'
class CheckQqToken
  @queue = :normal

  def self.perform(openid, token)
    info = RestClient.get "https://graph.qq.com/oauth2.0/me?access_token=#{token}"
    raise "QQ #{openid},#{token}认证失败" unless info.to_s.index(openid)
  end
  
end