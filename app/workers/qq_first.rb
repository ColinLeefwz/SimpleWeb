# coding: utf-8

class QqFirst
  @queue = :normal

  def self.perform(user_id)
    token = $redis.get("qqtoken#{user_id}")
    openid = User.find_by_id(user_id).qq
    do_share(token,openid)
  end
  
  def self.do_share(token,openid)
    RestClient.post("https://graph.qq.com/share/add_share",
    :access_token => token,
    :oauth_consumer_key => $qq_api_key,
    :openid => openid,
    :title => "我刚刚安装了脸脸手机应用",
    :url => "http://www.dface.cn/a?v=12",
    :summary => "脸脸,有点意思的现场社交应用。刚巧遇上了，没有什么特别的话想说，惟有轻轻地一句：“ 我在这里，你也来吧！“ iPhone版： http://www.dface.cn/a?v=13",
    :images => "http://dface.cn/images/logo2.png",
    :site => "http://www.dface.cn",
    :fromurl => "http://www.dface.cn/a?v=14",
    :nswb => 0)
  end
  
end
