# coding: utf-8

class InitController < ApplicationController
  def init
    hash = Digest::SHA1.hexdigest("#{params[:model]}#{params[:os]}#{params[:mac]}init")[0,32]
    if params[:hash].nil? || hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    session[:os] = UserDevice.os_type(params[:os])

    ver = params[:ver]
    ver_arr = ver.split(".")
    ver = ver_arr[0..2].inject {|sum,x| sum+"."+x}  if ver_arr.size>3 # "2.1.0.2.1.0" -> "2.1.0"
    if session[:user_id].nil?
      session[:user_dev] = UserDevice.init(params[:mac],params[:os],params[:model],ver,
        params[:screen_w],params[:screen_h],params[:id],params[:imei],params[:imsi],params[:channel]) 
    else
      UserDevice.update_redis(session[:user_id],session[:os],ver)
    end
    if session[:user_id] && ( "502e6303421aa918ba000001" == session[:user_id].to_s || "s" == session[:user_id].to_s[0])
      ip = $web_ips[2]
    else
      ip = $web_ip
    end
    if session[:user_id]
      seq = session[:user_id].to_s[0,8].to_i(16) % $xmpp_ips.size
      xmpp = $xmpp_ips[seq]
    else
      xmpp = Xmpp.cur_xmpp_ip
    end
    if session[:os] == 1
      version = android_version
      ver = version.to_f
    else
      version = "2.3.2"
      ver = 2.3
    end
    render :json => {ip: ip, xmpp: xmpp , ver:ver, version:version }.to_json
  end
  
 $ios = [
         ["2.0.0","界面全新改版",false],
         ["2.1.0","我的照片墙增加新评论提醒功能\n聊天室发图分享到微信朋友圈功能",true],
         ["2.2.0","增加了地主👑和抢地主功能\n添加地点功能强化",true],
         ["2.3.0","增加了手机号码功能\n好友动态提醒",true],
        ]
  
  def upgrade
    if session[:os] == 1
      version = Version.where({}).sort({_id: -1}).limit(1).first
      vs = [version.id, version.desc, version.upgrade]
      render :json => vs.to_json
    else
      render :json => $ios[-1].to_json
    end
  end

  
  
end
