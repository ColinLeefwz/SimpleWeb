# encoding: utf-8

class SmsSender
  @queue = :sms

  def self.perform(phone,text)
    send_sms_ihuiyi(phone, text)
  end
  
  def self.send_sms_ihuiyi(phone, text)
    return true if ENV["RAILS_ENV"] != "production"
    begin
      pass = URI.escape("www.dface.cn20130709")
      info = RestClient.get "http://106.ihuyi.com/webservice/sms.php?method=Submit&account=cf_llh&password=#{pass}&mobile=#{phone}&content=#{URI.escape(text)}"
      match = info.index("<code>2</code>")
      return true if match && match>0
      Xmpp.send_chat($gfuid, $yuanid, "短信错误：#{info}")
      return nil
    rescue Exception => e
      Xmpp.send_chat($gfuid, $yuanid, "短信错误：#{e}")
      return nil
    end
  end
  
  def self.ihuiyi_remain
    pass = URI.escape("www.dface.cn20130709")
    info = RestClient.get "http://106.ihuyi.com/webservice/sms.php?method=GetNum&account=cf_llh&password=#{pass}"
    
  end
  
  def self.send_sms_xuanwu(phone, text)
    return true if ENV["RAILS_ENV"] != "production"
    begin
      str = URI.encode(text.encode('gbk','utf-8'))
      info = RestClient.get "http://211.147.239.62:9050/cgi-bin/sendsms?username=test&password=11111&to=#{phone}&text=#{str}&msgtype=1"
      return if info=="0"
      Xmpp.send_chat($gfuid, $yuanid, "短信错误：#{info}")
      return nil
      end
    rescue Exception => e
      Xmpp.send_chat($gfuid, $yuanid, "短信错误：#{info}")
      return nil
    end
  end
  
  
end