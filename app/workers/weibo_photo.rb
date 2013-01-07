# encoding: utf-8

class WeiboPhoto
  @queue = :normal

  def self.perform(token, text, url)
    RestClient.post('https://api.weibo.com/2/statuses/upload_url_text.json', 
        :access_token  => token , :status => text+" \n(来自脸脸 http://www.dface.cn)", 
        :url => url)  {|response, request, result| puts response }
  end
end