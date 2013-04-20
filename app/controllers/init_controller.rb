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
      ver = 0.4
    else
      ver = 1.4
    end
    render :json => {ip: ip, xmpp: xmpp , ver:ver }.to_json
  end
  
  $ios = [
          ["2.0.0","界面全新改版",false],
          ["2.0.1","聊天室发图增加了分享到微信朋友圈和微信好友功能\n界面美化，更美观更清新",true]
         ]
  $android = []
  
  def upgrade
    if params[:os][0,7].downcase=="android"
      render :json => []
    else
      render :json => $ios[-1].to_json
    end
  end
  
end
