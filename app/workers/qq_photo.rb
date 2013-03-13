# coding: utf-8

class QqPhoto
  @queue = :normal

  def self.perform(user_id,title, text, url, comment)
    token = $redis.get("qqtoken#{user_id}")
    openid = User.find_by_id(user_id).qq
    do_share(token,openid, title, text, url,comment)
  end
  
  def self.do_share(token,openid,title, text, url, comment)
    RestClient.post("https://graph.qq.com/share/add_share",
    :access_token => token,
    :oauth_consumer_key => $qq_api_key,
    :openid => openid,
    :title => title,
    :comment => comment,
    :url => url,
    :summary => text,
    :images => url,
    :site => "http://www.dface.cn",
    :fromurl => "http://www.dface.cn/a?v=16",
    :nswb => 0)
  end
  
end
