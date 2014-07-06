# coding: utf-8

class WeiboFirst
  @queue = :normal

  def self.perform0(token)
    RestClient.post('https://api.weibo.com/2/statuses/upload_url_text.json', 
        :access_token  => token , :status => "#脸脸#有点意思的现场社交应用。刚巧遇上了，没有什么特别的话想说，惟有轻轻地一句：“ 我也在这里！” ，你也来吧！iPhone版： http://www.dface.cn/a?v=2", 
        :url => "http://www.dface.cn/intro.jpg")
  end
  
  def self.perform(token)
    begin
      perform0(token)
    rescue Exception => e
      return if e.to_s[0,3]=="403"  || e.to_s[0,3]=="400"
      raise e
    end
  end
  
  
end