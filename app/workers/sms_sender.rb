# encoding: utf-8

class SmsSender
  extend PhoneUtil 
  @queue = :sms

  def self.perform(phone,text)
    send_sms_ihuiyi(phone, text)
  end
  
  def self.send_sms_ihuiyi(phone, text)
      return true if ENV["RAILS_ENV"] != "production"
      pass = URI.escape("www.dface.cn20130709")
      info = RestClient.get "http://106.ihuyi.com/webservice/sms.php?method=Submit&account=cf_llh&password=#{pass}&mobile=#{phone}&content=#{URI.escape(text)}"
      match = info.index("<code>2</code>")
      return true if match && match>0
      Xmpp.send_chat($gfuid, $yuanid, "短信错误：#{Time.now},#{text}")
      Rails.logger.warn "短信错误：#{Time.now},#{text}"
      Rails.logger.warn info
      Xmpp.send_chat($gfuid, $yuanid, info)
      return nil
  end
  
  def self.ihuiyi_remain
    pass = URI.escape("www.dface.cn20130709")
    info = RestClient.get "http://106.ihuyi.com/webservice/sms.php?method=GetNum&account=cf_llh&password=#{pass}"
    
  end
  
  def self.send_sms_xuanwu(phone, text)
      return true if ENV["RAILS_ENV"] != "production"
      text += "“回复TD退订”" if is_dianxin(phone)
      str = URI.encode(text.encode('gbk','utf-8'))
      info = RestClient.get "http://211.147.239.62:9050/cgi-bin/sendsms?username=cadmin@zjll&password=Dface.cn1234&to=#{phone}&text=#{str}&msgtype=1"
      return true if info=="0"
      Xmpp.send_chat($gfuid, $yuanid, "短信错误：#{Time.now},#{info}")
      return nil
  end
  
  
end