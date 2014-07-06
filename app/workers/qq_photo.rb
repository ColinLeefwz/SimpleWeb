# coding: utf-8

class QqPhoto
  @queue = :normal

  def self.perform(user_id,title, text, url, comment, img)
    token = $redis.get("qqtoken#{user_id}")
    openid = User.find_by_id(user_id).qq
    do_share(token,openid, title, text, url,comment,img)
  end
  
  def self.do_share(token,openid,title, text, url, comment, img)
    response = RestClient.post("https://graph.qq.com/share/add_share",
    :access_token => token,
    :oauth_consumer_key => $qq_api_key,
    :openid => openid,
    :title => title,
    :comment => comment,
    :url => url,
    :summary => text,
    :images => img,
    :site => "http://www.dface.cn",
    :fromurl => "http://www.dface.cn/a?v=16",
    :nswb => 0)
    json = JSON.parse(response)
    raise json["msg"] if json["ret"]!=0
  end
  
end
