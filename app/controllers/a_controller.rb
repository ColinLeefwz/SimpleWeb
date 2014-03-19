# coding: utf-8

class AController < ApplicationController
  
  before_filter :weixin_filter, :only => [:index, :webdown]
  
  #$apk_url = "http://dd.myapp.com/16891/external_EC325DF2C79795CCE3725D873B97B775.apk"  #二次扫描不行  
  $apk_url = "http://android.myapp.com/android/down.jsp?appid=1064735&pkgid=17697967&icfa=-1&lmid=1022&g_f=990976&actiondetail=0&downtype=1&transactionid=1395212192718252&topicid=-1&softname=%E8%84%B8%E8%84%B8"
  
  $ios_url = "https://itunes.apple.com/cn/app/lianlian/id577710538"
  
  #通过二维码下载
  def index
    c = save_channel(params[:v])
    Rails.logger.error c.agent
    agent = c.agent.downcase
    #Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/9B206 MicroMessenger/5.0.3
    #Mozilla/5.0 (Linux; U; Android 2.3.4; zh-cn; WT19i Build/4.0.2.A.0.62) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1 MicroMessenger/4.5.255

    if params[:x].nil?  #不带x则尝试直接下载
      if c.agent.index("Android")
        if c.agent.index("MicroMessenger/4")
          return render :file => "~/lianlian/public/mini.html", :use_full_path => true 
        elsif c.agent.index("MicroMessenger")
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
  
  #官网直接android下载，可以考虑取消
  def down
    c = save_channel("0")
    if c.agent.index("Android")
      if c.agent.index("MicroMessenger")
        return redirect_to $apk_url
      end
    end
    ver = $redis.get("android_version")
    redirect_to "http://oss.aliyuncs.com/dface/dface#{ver}.apk"
  end
  
  #由于在微信的网页中无法打开app store，而通过微信二维码扫描却可以，所以在网页中点击下载使用本方法
  def webdown
    c = save_channel(params[:v])
    Rails.logger.error c.agent
    agent = c.agent.downcase
    if c.agent.index("Android")
      if c.agent.index("MicroMessenger/4")
        return render :file => "~/lianlian/public/mini.html", :use_full_path => true 
      elsif c.agent.index("MicroMessenger")
        return redirect_to $apk_url
      else
        ver = $redis.get("android_version")
        return redirect_to "http://oss.aliyuncs.com/dface/dface#{ver}.apk"
      end
    end
    if agent.index("iphone") || agent.index("ipad")
      if c.agent.index("MicroMessenger")
        return render :file => "~/lianlian/public/wx_down.html", :use_full_path => true 
      else
        return redirect_to $ios_url
      end
    end
    if agent.index("windows")
      return redirect_to $apk_url
    end
    render :file => "~/lianlian/public/mini.html", :use_full_path => true 
  end
  
  def xmpp_test
    begin
      Xmpp.test
      render :text => "ok"
    rescue Exception => e
      render :text => e.to_s, :status => 500
    end
  end
  
  private 
  
  def save_channel(v)
    c = Channel.new
    c.ip = real_ip
    c.v = v
    c.time = Time.now
    c.agent = request.env["HTTP_USER_AGENT"]
    c.save
    c
  end
  
end
