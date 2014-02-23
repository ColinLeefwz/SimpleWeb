# encoding: utf-8

class SmsSender
  extend PhoneUtil 
  @queue = :sms

  def self.perform(phone,text)
    v = Rails.cache.read("Sms#{phone}")
    if v.nil?
      if is_yidong(phone) || is_liantong(phone)
        send_sms_xuanwu(phone, text)
      else
        send_sms_ihuiyi(phone, text)
      end
      Rails.cache.write("Sms#{phone}",Time.now.to_i, :expires_in => 1.days)
    else
      diff = Time.now.to_i - v.to_i
      if diff>30
        send_sms_ihuiyi(phone, text)
      else
        Xmpp.error_notify("重发请求短信验证码,#{phone}在#{diff}秒内")
      end
    end
  end
  
  def self.send_sms_ihuiyi(phone, text)
      return true if ENV["RAILS_ENV"] != "production"
      pass = URI.escape("www.dface.cn20130709")
      info = RestClient.get "http://106.ihuyi.com/webservice/sms.php?method=Submit&account=cf_llh&password=#{pass}&mobile=#{phone}&content=#{URI.escape(text)}"
      match = info.index("<code>2</code>")
      return true if match && match>0
      Xmpp.error_notify("ihuiyi短信错误：#{Time.now},#{phone_operator(phone)} #{phone}")
      Xmpp.error_notify(info)
      Xmpp.error_notify(info.encode('utf-8','gbk'))
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
      Xmpp.error_notify("玄武短信错误：#{Time.now},#{info}")
      return nil
  end
    
  def self.send_sms_mandao(phone, text)
      return true if ENV["RAILS_ENV"] != "production"
      str = text.encode('gbk','utf-8')
      info = RestClient.post "http://sdk2.entinfo.cn:8060/webservice.asmx/SendSMS", 
        :sn => "SDK-NSF-010-00034", :pwd => "DD07e9-8", :mobile => phone, :content => str
      return true if info.index(">0 ")
      Xmpp.error_notify("漫道短信错误：#{Time.now},#{info}")
      return nil
  end
  
  #sleep 30;["18665313145","18679426779","15158000625","15397888138","18910803153"].each {|phone| SmsSender.send_sms_xuanwu(phone,"测试#{Time.now.to_s}")}
  #测试结果 ： 玄武不能发电信，漫道不能发联通
    
end