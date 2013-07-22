# encoding: utf-8

class SmsSender
  @queue = :sms

  def self.perform(phone,text)
    send_sms_ihuiyi(phone, text)
  end
  
  def self.send_sms_ihuiyi(phone, text)
    return true if ENV["RAILS_ENV"] != "production"
    return true if phone[0,3]=="000"
    begin
      pass = URI.escape("www.dface.cn20130709")
      info = RestClient.get "http://106.ihuyi.com/webservice/sms.php?method=Submit&account=cf_llh&password=#{pass}&mobile=#{phone}&content=#{URI.escape(text)}"
      return info.index("<code>2</code>")>0
    rescue Exception => e
      puts e
      puts e.backtrace
      return nil
    end
  end
  
end