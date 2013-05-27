# coding: utf-8

class InitController < ApplicationController
  def init
    hash = Digest::SHA1.hexdigest("#{params[:model]}#{params[:os]}#{params[:mac]}init")[0,32]
    if params[:hash].nil? || hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    session[:ver]=params[:ver]
    session[:os] = UserDevice.os_type(params[:os])
    session[:user_dev] = UserDevice.init(params[:mac],params[:os],params[:model],params[:ver],
                                          params[:screen_w],params[:screen_h])
    if "502e6303421aa918ba000001" == session[:user_id].to_s
      ip = $web_ips[2]
    else
      ip = $web_ip
    end
    if "502e6303421aa918ba000001" == session[:user_id].to_s
      xmpp = $xmpp_ips[3]
    else
      xmpp = $xmpp_ip
    end
    if session[:os] == 1
      ver = android_version
    else
      ver = 2.1
    end
    render :json => {ip: ip, xmpp: xmpp , ver:ver }.to_json
  end
  
  $ios = [
          ["2.0.0","界面全新改版",false],
          ["2.1.0","我的照片墙增加新评论提醒功能\n聊天室发图分享到微信朋友圈功能",true]
         ]
  $android = [
    ["1.0","重大功能调整",false]    
  ]
  
  def upgrade
    if session[:os] == 1
      render :json => $android[-1].to_json
    else
      render :json => $ios[-1].to_json
    end
  end
  
end
