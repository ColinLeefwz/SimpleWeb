# coding: utf-8

require 'oauth2'
require 'rest_client'

class Oauth2Controller < ApplicationController
  
  def hello
    render :text => (session[:user_id].to_s + ".")
  end
  
  def sina_client
    client = OAuth2::Client.new($sina_api_key,$sina_api_key_secret,:site => 'https://api.weibo.com/')
    client.options[:authorize_url] = "/oauth2/authorize"
    client.options[:token_url] = "/oauth2/access_token"
    client
  end

  def sina_new
    @@client ||= sina_client
    #render :text => 
    redirect_to @@client.auth_code.authorize_url(:redirect_uri => $sina_callback)
  end

  #使用sina oauth2认证时的回调页
  def sina_callback
    if params[:code].nil?
      render :json => params.to_json
      return
    end
    @@client ||= sina_client
    token = @@client.auth_code.get_token(params[:code], :redirect_uri => $sina_callback, :parse => :json )
    uid = token.params["uid"]
    if params[:bind].to_i==1
      bind_sina(uid,token.token)
    else
      data = {:token=> token.token, :expires_in => token.expires_in, :expires_at => token.expires_at, :wb_uid => uid }
      do_login(uid,token.token,data)
    end
  end
  
  def test_login
    return if ENV["RAILS_ENV"] != "test"
    session[:user_id] = User.find(params[:id]).id
    render :json => {}
  end

  #提供给手机客户端的认证服务
  def login
    hash = Digest::SHA1.hexdigest("#{params[:name]}#{params[:pass]}#{params[:mac]}dface")[0,32]
    if hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    begin
      response = RestClient.post 'https://api.weibo.com/oauth2/access_token', 
      :client_id => $sina_api_key, :client_secret => $sina_api_key_secret, :grant_type => 'password', 
      :username => params[:name], :password => params[:pass]
    rescue RestClient::BadRequest
      render :json => {:error => "密码或用户名输入错误！"}.to_json
      return
    rescue Exception
      render :json => {:error => "e未知原因的登陆失败，请稍后重试！"}.to_json
      return
    end
    token = ActiveSupport::JSON.decode response.to_s
    #logger.debug response.to_s
    uid = token["uid"]
    if params[:bind].to_i==1
      bind_sina(uid,token["access_token"])
    else
      data = {:token=> token["access_token"], :expires_in => token["expires_in"], :expires_at => token["expires_at"], :wb_uid => uid }
      do_login(uid,token["access_token"],data)
    end
  end
  
  def sso
    uid = params[:uid]
    token = params[:access_token]
    #TODO: 确认该:access_token是新浪真实授权的
    hash = Digest::SHA1.hexdigest("#{uid}#{token}dface")[0,32]
    if hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    if params[:bind].to_i==1
      bind_sina(uid,token)
    else
      data = {}
      do_login(uid,token,data)
    end
  end

  def qq_client
    openid = params[:openid]
    token = params[:access_token]
    hash = Digest::SHA1.hexdigest("#{openid}#{token}dface")[0,32]
    if hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    if params[:bind].to_i==1
      bind_qq(openid,token)
    else
      data = {}
      do_login_qq(openid,token,data)
    end
  end
  
  def unbind_qq
    if session[:user_id].nil?
      render :json => {error: "未登录"}.to_json
      return
    end
    if session_user.wb_uid.nil?
      render :json => {error: "不能解除唯一登录帐号的绑定"}.to_json
      return
    end
    if session_user.qq.nil?
      render :json => {error: "您没有绑定过qq帐号"}.to_json
      return
    end    
    session_user.update_attribute(:qq, nil)
    $redis.del("qqtoken#{session_user.id}")
    render :json => {unbind: true}.to_json
  end

  def unbind_sina
    if session[:user_id].nil?
      render :json => {error: "未登录"}.to_json
      return
    end
    if session_user.wb_uid.nil?
      render :json => {error: "您没有绑定过新浪微博帐号"}.to_json
      return
    end
    if session_user.qq.nil?
      render :json => {error: "不能解除唯一登录帐号的绑定"}.to_json
      return
    end    
    session_user.update_attribute(:wb_uid, nil)
    $redis.del("qqtoken#{session_user.id}")
    render :json => {unbind: true}.to_json
  end
  
      
  def logout
    if session[:user_id].nil?
      render :json => {error: "未登录"}.to_json
      return
    end
    if params[:pushtoken] && session_user.tk==params[:pushtoken]
      session_user.unset(:tk)
    end
    clear_session_info
    render :json => {"logout" => true}.to_json
  end

  def share
    Resque.enqueue(WeiboFirst, $redis.get("wbtoken#{session_user.id}") )
    render :json => {"shared" => true}.to_json
  end  
  


  #提供给erlang系统的内部认证服务
  def auth
    if params[:name][0]=='s'
      if params[:pass][0,4] == 'pass'
        render :text => "1"
        return
      end
    else
      pass = params[:pass]
      if pass.length>(1+64) #硬编码了token的长度：64
	      ptoken = params[:pass][-65..-1]
        pass = pass[0..-66]
      end
      user = User.find_by_id(params["name"])
      if user.password == pass
	      logger.warn "token:#{ptoken}"
        if ptoken && (user.tk.nil? || user.tk[0] != ptoken[0])
          User.collection.find({_id:user._id}).update("$set" => {tk:ptoken}) 
        end
        render :text => "1"
        return
      end
    end
    render :text => "0"
  end
  
  def push_msg_info
    logger.warn "params['from'],params['to']"
    if params["from"][0]=='s'
      fu = Shop.find_by_id(params["from"][1..-1])
    else
      fu = User.find_by_id(params["from"])
    end
    tu = User.find_by_id(params["to"]) #TODO: 商家的Push消息提醒
    if fu && tu
      render :text => "#{tu.tk}#{fu.name}"
    else
      render :text => ""
    end
  end
  
  private
  
  def clear_session_info
    $redis.del("wbtoken#{session[:user_id]}")
    $redis.del("qqtoken#{session[:user_id]}")
    reset_session
  end
  
  def bind_qq(openid,token)
    if session[:user_id].nil?
      render :json => {error: "未登录"}.to_json
      return
    end
    if session_user.qq
      render :json => {error: "已经绑定了qq帐号"}.to_json
      return
    end
    #TODO: 调用https://graph.qq.com/oauth2.0/me?access_token= 来判断openid的真实性。
    #TODO: openid重复监测
    session_user.update_attribute(:qq, openid)
    $redis.set("qqtoken#{session[:user_id]}",token)
    render :json => {binded: true}.to_json
  end

  def bind_sina(wb_uid,token)
    if session[:user_id].nil?
      render :json => {error: "未登录"}.to_json
      return
    end
    if session_user.wb_uid
      render :json => {error: "已经绑定了新浪微博帐号"}.to_json
      return
    end
    #TODO: wb_uid重复监测
    session_user.update_attribute(:wb_uid, wb_uid)
    $redis.set("wbtoken#{session[:user_id]}",token)
    render :json => {binded: true}.to_json
  end  
  
  def do_login(uid,token,data)
    clear_session_info
    user = User.where({wb_uid: uid}).first
    if user.nil? || user.auto
      user = gen_new_user(uid,token) if user.nil?
      change_auto_user(user) if user.auto
      session[:new_user_flag] = true
      Resque.enqueue(WeiboFriend, token,uid,user.id)
      #Resque.enqueue(WeiboFirst, token)
    end
    if user.forbidden?
      render :json => {error:"forbidden."}.to_json
      return
    end
    session[:user_id] = user.id
    $redis.set("wbtoken#{user.id}",token)
    data.merge!( {:id => user.id, :password => user.password, :name => user.name, :gender => user.gender} )
    data.merge!( user.head_logo_hash  )
	  render :json => data.to_json
  end

  def do_login_qq(openid,token,data)
    clear_session_info
    user = User.where({qq: openid}).first
    if user.nil?
      user = gen_new_user_qq(openid,token)
      return if user.nil?
      session[:new_user_flag] = true
    end
    if user.forbidden?
      render :json => {error:"forbidden."}.to_json
      return
    end
    session[:user_id] = user.id
    $redis.set("qqtoken#{user.id}",token)
    data.merge!( {:id => user.id, :password => user.password, :name => user.name, :gender => user.gender} )
    data.merge!( user.head_logo_hash  )
	  render :json => data.to_json
  end
    
  def change_auto_user(user)
    user.auto = false
    user.head_logo_id = nil
    user.pcount = 0
    user.atime = Time.now
    user.password = Digest::SHA1.hexdigest(":dface#{user.wb_uid}")[0,16]
    user.save!
  end
  
  def gen_new_user(uid,token)
    sina_info = SinaUser.get_user_info(uid,token)
    #SinaUser.collection.insert(sina_info)
    user = User.new
    user.wb_uid = uid
    user.password = Digest::SHA1.hexdigest(":dface#{user.wb_uid}")[0,16]
    if sina_info
      if sina_info["screen_name"].length<10
        user.name = sina_info["screen_name"]
      else
        user.name = ""
      end
      user.gender = 1 if sina_info["gender"]=="m"
      user.gender = 2 if sina_info["gender"]=="f"
      if sina_info["verified"]
        user.wb_v = sina_info["verified"] 
        user.wb_vs = sina_info["verified_reason"]
      end
      user.wb_name = sina_info["screen_name"]
      user.wb_g = user.gender
    end
    user.save!
    user
  end

  def gen_new_user_qq(openid,token)
    info = nil
    begin
      info = RestClient.get "https://graph.qq.com/user/get_simple_userinfo?access_token=#{token}&oauth_consumer_key=#{$qq_api_key}&openid=#{openid}"
    rescue Exception => e
      puts e.backtrace
      render :json => {error: e.to_s}.to_json
      return nil
    end
    info = ActiveSupport::JSON.decode(info)
    if info["ret"]!=0
      render :json => {error: info["ret"].to_s+","+info["msg"] }.to_json
      return nil
    end
    user = User.new
    user.qq = openid
    user.password = Digest::SHA1.hexdigest(":dface#{user.qq}")[0,16]
    user.name = info["nickname"]
    user.save!
    user
  end  
  
end
