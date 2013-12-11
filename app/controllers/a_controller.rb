# coding: utf-8

class AController < ApplicationController
  
  before_filter :weixin_filter, :only => [:index]
  
  
  def index
    c = Channel.new
    c.ip = real_ip
    c.v = params[:v] #1微博来自脸脸，2首次发微博分享, 3照片链接， 4二维码
    c.time = Time.now
    c.agent = request.env["HTTP_USER_AGENT"]
    c.save
    
    agent = c.agent.downcase

    if params[:v] == "1-apk"
      ver = $redis.get("android_version")
      return redirect_to "http://oss.aliyuncs.com/dface/dface#{ver}.apk"
    end

    #Rails.logger.error c.agent
    #Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; TencentTraveler)
    if params[:sukey] && c.agent.index("TencentTraveler")
      render :text => "请点击右上地址栏中的 '查看原网页 >' "
      return
    end
    #Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/9B206 MicroMessenger/5.0.3
    if agent.index("android")
      ver = $redis.get("android_version")
      return redirect_to "http://oss.aliyuncs.com/dface/dface#{ver}.apk"
    end
    if agent.index("iphone") || agent.index("ipad")
      return redirect_to "https://itunes.apple.com/cn/app/lianlian/id577710538"
    end        
    
    case params[:v]
    when '19'
      render :file => "~/lianlian/public/mini2.html", :use_full_path => true
    when '24'
      render :file => "~/lianlian/public/zhaopin.html", :use_full_path => true
    when '25'
      render :file => "~/lianlian/public/w/single/index.html", :use_full_path => true
    else
      render :file => "~/lianlian/public/mini.html", :use_full_path => true 
    end
    
  end
  
  def down
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
