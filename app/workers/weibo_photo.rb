# encoding: utf-8

class WeiboPhoto
  @queue = :normal

  def self.perform0(token, text, url)
    RestClient.post('https://api.weibo.com/2/statuses/upload_url_text.json', 
        :access_token  => token , :status => text[0..139], 
        :url => url)
  end
  
  def self.perform(token, text, url)
    begin
      perform0(token, text, url)
    rescue Exception => e
      #return if e.to_s[0,3]=="403"  || e.to_s[0,3]=="400"
      raise e
    end
  end
  
  
end