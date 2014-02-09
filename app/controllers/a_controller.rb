# coding: utf-8

class AController < ApplicationController
  
  before_filter :weixin_filter, :only => [:index]
  
  #$apk_url = "http://dd.myapp.com/16891/external_EC325DF2C79795CCE3725D873B97B775.apk"  #二次扫描不行
  $apk_url = "http://android.myapp.com/android/down.jsp?type=2&appid=1064735&pkgid=17363330&icfa=-1&g_f=990976"
  $ios_url = "https://itunes.apple.com/cn/app/lianlian/id577710538"
  
  def index
    c = Channel.new
    c.ip = real_ip
    c.v = params[:v] #1微博来自脸脸，2首次发微博分享, 3照片链接， 4二维码
    c.time = Time.now
    c.agent = request.env["HTTP_USER_AGENT"]
    c.save
    Rails.logger.error c.agent
    agent = c.agent.downcase
    #Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/9B206 MicroMessenger/5.0.3
    #Mozilla/5.0 (Linux; U; Android 2.3.4; zh-cn; WT19i Build/4.0.2.A.0.62) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1 MicroMessenger/4.5.255

    if params[:x].nil?  #不带x则尝试直接下载
      if c.agent.index("Android")
        if c.agent.index("MicroMessenger")
          return redirect_to $apk_url
          #render :file => "~/lianlian/public/wx_down.html", :use_full_path => true
          return
        else
          ver = $redis.get("android_version")
          return redirect_to "http://oss.aliyuncs.com/dface/dface#{ver}.apk"
        end
      end
      if agent.index("iphone") || agent.index("ipad")
        return redirect_to $ios_url
      end
      if agent.index("windows")
        return redirect_to $apk_url
      end
    end
    
    case params[:v]
    when '19'
      render :file => "~/lianlian/public/mini2.html", :use_full_path => true
    when '24'
      render :file => "~/lianlian/public/zhaopin.html", :use_full_path => true
    when '25'
      render :file => "~/lianlian/public/w/single/index.html", :use_full_path => true
    when "50"
      render :file => "~/lianlian/public/w/zwyd/index.html", :use_full_path => true
    when "60001"
      render :file => "~/lianlian/public/w/zf1314/zf.html", :use_full_path => true
    when "60002"
      render :file => "~/lianlian/public/w/zf1314/index.html", :use_full_path => true
    else
      render :file => "~/lianlian/public/mini.html", :use_full_path => true 

    end
    
  end
  
  def down
    c = Channel.new
    c.ip = real_ip
    c.v = 0
    c.time = Time.now
    c.agent = request.env["HTTP_USER_AGENT"]
    c.save
    if c.agent.index("Android")
      if c.agent.index("MicroMessenger")
        return redirect_to $apk_url
        #return render :file => "~/lianlian/public/mini.html", :use_full_path => true
      end
    end
    ver = $redis.get("android_version")
    redirect_to "http://oss.aliyuncs.com/dface/dface#{ver}.apk"
  end
  
  def xmpp_test
    begin
      Xmpp.test
      render :text => "ok"
    rescue Exception => e
      render :text => e.to_s, :status => 500
    end
  end
  
end
