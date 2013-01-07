# coding: utf-8

class WeiboFirst
  @queue = :normal

  def self.perform(token)
    RestClient.post('https://api.weibo.com/2/statuses/upload_url_text.json', 
        :access_token  => token , :status => "刚巧遇上了，没有什么特别的话想说，惟有轻轻地一句：“ 我也在这里！” #脸脸#有点意思的现场社交应用，你也来吧！Iphone版： http://t.cn/zjOsTCH", 
        :url => "http://www.dface.cn/twocode/images/lianlian.jpg")  {|response, request, result| puts response }
  end
end