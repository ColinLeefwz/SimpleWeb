# coding: utf-8

class InitController < ApplicationController
  def init
    hash = Digest::SHA1.hexdigest("#{params[:model]}#{params[:os]}#{params[:mac]}init")[0,32]
    if params[:hash].nil? || hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    logger.info "INIT: #{params[:model]} , #{params[:os]} , #{params[:mac]}, #{params[:ver]}"
    session[:ver]=params[:ver]
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
    if params[:os][0,7].downcase=="android"
      ver = 0.51
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
    ["0.5","重大功能调整",true]    
  ]
  
  def upgrade
    if params[:os][0,7].downcase=="android"
      render :json => $android[-1].to_json
    else
      render :json => $ios[-1].to_json
    end
  end
  
end
