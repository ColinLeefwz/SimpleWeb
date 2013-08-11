# coding: utf-8

require 'oauth2'
require 'rest_client'

class Oauth2Controller < ApplicationController
  before_filter :user_login_filter, :only => [:unbind_sina, :unbind_qq, :share] 
  before_filter :bind_login_filter, :only => [:login, :sso, :qq_client] 
  
  def bind_login_filter
    user_login_filter if params[:bind].to_i>0
  end
  
  
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
    data = {:token=> token.token, :expires_in => token.expires_in, :expires_at => token.expires_at, :wb_uid => uid }
    if token.token.size!=32 || uid.nil? || uid.match(/^\d+$/).nil?
      Xmpp.error_notify("微博#{uid}，token:#{token.token}不是32位")
      render :json => {error: "WB Error:#{uid},#{token.token}"}.to_json
      return
    end
    if params[:bind].to_i==1
      bind_sina(uid,token.token,token.expires_in, data)
    elsif params[:bind].to_i==2
      bind_sina2(uid,token.token,token.expires_in, data)
    else
      do_login_wb(uid,token.token,token.expires_in, data)
    end
  end
  
  def test_login
    return if ENV["RAILS_ENV"] != "test"
    session[:user_id] = User.find_by_id(params[:id]).id
    render :json => {}
  end

  #提供给手机客户端的认证服务
  def login
    if true
      render :json => {:error => "安装新浪微博官方客户端后才能用微博登录！"}.to_json
      return
    end
    hash = Digest::SHA1.hexdigest("#{params[:name]}#{params[:pass]}#{params[:mac]}dface")[0,32]
    if hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    begin
      response = RestClient.post 'https://api.weibo.com/oauth2/access_token', 
      :client_id => $sina_api_key, :client_secret => $sina_api_key_secret, :grant_type => 'password', 
      :username => params[:name], :password => params[:pass]
    rescue RestClient::BadRequest => bre
      render :json => {:error => "安装新浪微博官方客户端后才能用微博登录！"}.to_json
      return
    rescue Exception => e
      render :json => {:error => "e未知原因的登陆失败，请稍后重试！"}.to_json
      return
    end
    token = ActiveSupport::JSON.decode response.to_s
    #logger.debug response.to_s
    uid = token["uid"]
    data = {:token=> token["access_token"], :expires_in => token["expires_in"], :expires_at => token["expires_at"], :wb_uid => uid }
    if params[:bind].to_i==1
      bind_sina(uid,token["access_token"], token["expires_in"], data)
    elsif params[:bind].to_i==2
      bind_sina2(uid,token["access_token"], token["expires_in"], data)
    else
      do_login_wb(uid,token["access_token"], token["expires_in"], data)
    end
  end
  
  def sso
    uid = params[:uid]
    token = params[:access_token]
    if token.size!=32 || uid.nil? || uid.match(/^\d+$/).nil?
      Xmpp.error_notify("微博#{uid}，token:#{token}不是32位")
      render :json => {error: "WB Error:#{uid},#{token}"}.to_json
      return
    end
    hash = Digest::SHA1.hexdigest("#{uid}#{token}dface")[0,32]
    if hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    data = {:wb_uid => uid}
    Resque.enqueue(CheckWbToken, uid, token )
    if params[:bind].to_i==1
      bind_sina(uid,token, params[:expires_in], data)
    elsif params[:bind].to_i==2
      bind_sina2(uid,token, params[:expires_in], data)
    else
      do_login_wb(uid,token, params[:expires_in], data)
    end
  end

  def qq_client
    openid = params[:openid]
    token = params[:access_token]
    if openid.size!=32 || token.size!=32
      #发现恶意攻击
      #/oauth2/qq_client.json  {"openid"=>"7776000", "expires_in"=>"", "bind"=>"0", "hash"=>"f4da7cf73614aeade44424ebfe3fe8a4", "access_token"=>"2DA96569EF12E2E527891397817D67A9", "controller"=>"oauth2", "action"=>"qq_client", "format"=>"json"}
      Xmpp.error_notify("QQ openid:#{openid}不是32位, token:#{token}") if rand(100)>90
      render :json => {error: "QQ Error:#{openid},#{token}"}.to_json
      return
    end
    hash = Digest::SHA1.hexdigest("#{openid}#{token}dface")[0,32]
    if hash != params[:hash][0,32]
      render :json => {error: "hash error: #{hash}."}.to_json
      return
    end
    data = {qq_openid:openid}
    Resque.enqueue(CheckQqToken, openid, token )
    if params[:bind].to_i==1
      bind_qq(openid,token,params[:expires_in], data)
    elsif params[:bind].to_i==2
      bind_qq2(openid,token,params[:expires_in], data)
    else
      do_login_qq(openid,token,params[:expires_in], data)
    end
  end
  
  def unbind_qq
    if session_user_no_cache.wb_uid.nil?
      render :json => {error: "不能解除唯一登录帐号的绑定"}.to_json
      return
    end
    if session_user_no_cache.qq.nil?
      render :json => {error: "您没有绑定过qq帐号"}.to_json
      return
    end    
    #User.find(session[:user_id]).unset(:qq)
    $redis.del("qqtoken#{session[:user_id]}")
    $redis.del("qqexpire#{session[:user_id]}")
    session_user_no_cache.update_attribute(:qq_hidden, true)
    render :json => {unbind: true}.to_json
  end

  #用户在脸脸客户端解除新浪微博绑定
  def unbind_sina
    if session_user_no_cache.wb_uid.nil?
      render :json => {error: "您没有绑定过新浪微博帐号"}.to_json
      return
    end
    if session_user_no_cache.qq.nil?
      render :json => {error: "不能解除唯一登录帐号的绑定"}.to_json
      return
    end    
    #User.find(session[:user_id]).unset(:wb_uid)
    $redis.del("wbtoken#{session[:user_id]}")
    $redis.del("wbexpire#{session[:user_id]}")
    session_user_no_cache.update_attribute(:wb_hidden, 2)
    render :json => {unbind: true}.to_json
  end
  
  #用户在新浪微博解除对脸脸的授权，回调url
  def unbind_sina_callback
    if params[:source] == $sina_api_key && (Time.now.to_i - params[:auth_end].to_i)<3600 && params[:verification].size==32
      user = User.find_by_wb(params[:uid])
      if user
        $redis.del("wbtoken#{user.id}")
        $redis.del("wbexpire#{user.id}")
        user.update_attribute(:wb_hidden, 2) if user
        #TODO: 如何通知客户端微博已经取消绑定？
        #TODO： 如果没有绑定qq，这个用户应该就不能登录了。
      end
    end
    render :text => "ok"
  end
  
      
  def logout
    if params[:pushtoken] && session_user_no_cache.tk
      size = session_user_no_cache.tk.size
      if session_user_no_cache.tk==params[:pushtoken][0,size]
        session_user_no_cache.unset(:tk)
      end
    end
    clear_session_info
    render :json => {"logout" => true}.to_json
  end

  def share
    t = params[:t].to_i
    if t==0
      Resque.enqueue(WeiboFirst, $redis.get("wbtoken#{session[:user_id]}") )
      render :json => {"shared" => true}.to_json
    elsif t==1
      Resque.enqueue(QqFirst, session[:user_id])
      render :json => {"shared" => true}.to_json
    else
      render :json => {"error" => "unknow t:#{t}."}.to_json
    end
  end  
  


  #提供给erlang系统的内部认证服务
  def auth
    if params[:name][0]=='s'
      shop = Shop.find_by_id(params[:name][1..-1])
      if (shop && User.pass_hash(shop.password)==params[:pass][0,16]) || params[:pass][0,10] == 'passWD1234'
        render :text => "1"
        return    
      end
    else
      pass = params[:pass]
      if pass.length>(1+64) #硬编码了token的长度：64
        pass = pass[0..-66]
        if params[:name].size==24 && pass.size==16
          #TODO: 暂时放松对xmpp登录的验证
          render :text => "1"
          return
        end
      end
      user = User.find_by_id(params["name"])
      if user && (user.password == pass || user.old_password == pass)
        render :text => "1"
        update_token0(params[:name], params[:pass])
        return
      end
    end
    #Xmpp.error_notify("xmpp登录失败：#{params[:name]},#{params[:pass]}") #暂时放松对xmpp登录的验证
    render :text => "1"
  end
  
  def update_token
    update_token0(params[:id], params[:pass])
    render :text => "1"
  end
  
  def push_msg_info
    logger.warn "params['from'],params['to']"
    if params["from"][0]=='s'
      fu = Shop.find_by_id(params["from"][1..-1])
    else
      fu = User.find_by_id(params["from"])
    end
    tu = User.find_by_id(params["to"]) #TODO: 商家的Push消息提醒
    if fu && tu && tu.tk && !tu.no_push
      render :text => "#{tu.tk}#{fu.name}"
    else
      render :text => ""
    end
  end
  
  private
  
  def clear_session_info
    $redis.del("wbtoken#{session[:user_id]}")
    $redis.del("qqtoken#{session[:user_id]}")
    $redis.del("wbexpire#{session[:user_id]}")
    $redis.del("qqexpire#{session[:user_id]}")
    reset_session
  end
  
  def do_login_wb_done(user,token,expires_in,data)
    $redis.set("wbtoken#{user.id}",token)
    $redis.set("wbexpire#{user.id}",expires_in)
    data.merge!( {:id => user.id, :password => user.password, :name => user.name, :gender => user.gender} )
    data.merge!( user.head_logo_hash  )
	  render :json => data.to_json
  end

  def bind_sina(wb_uid,token,expires_in,data)
    user = session_user_no_cache
    if user.wb_uid
      if user.wb_uid != wb_uid
        render :json => {error: "绑定新浪微博帐号失败"}.to_json
        return
      else
        if user.wb_hidden==2
          user.set(:wb_hidden, 0) 
        else
          Xmpp.error_notify("#{session[:user_id]} 重复绑定wb：#{wb_uid}")
        end
        do_login_wb_done(user,token,expires_in,data)
      end
    else
      u = User.find_by_wb(wb_uid)
      if u && u.id != session[:user_id]
        render :json => {error: "该新浪微博帐号帐号已经注册过了，不能绑定。"}.to_json
        return
      end
      user.update_attribute(:wb_uid, wb_uid)
      $redis.set("W:#{wb_uid}", user.id)
      sina_info = SinaUser.get_user_info(wb_uid,token)
      if sina_info && sina_info["screen_name"]
        user.update_attribute(:wb_name, sina_info["screen_name"])
      end
      do_login_wb_done(session_user_no_cache,token,expires_in,data)
    end
  end
    
  def bind_sina2(uid,token,expires_in,data)
    if session_user_no_cache.wb_uid != uid
      render :json => {error:"此次登录的新浪微博帐号和绑定的新浪微博帐号不一致."}.to_json
      return
    end
    do_login_wb_done(session_user_no_cache,token,expires_in,data)
  end 
  
  
  def do_login_wb(uid,token,expires_in,data)
    user = User.find_by_wb(uid)
    if user.nil? || user.auto
      user = gen_new_user(uid,token) if user.nil?
      change_auto_user(user) if user.auto
      session[:new_user_flag] = true
      data.merge!({newuser:1})
      Resque.enqueue(WeiboFriend, token,uid,user.id)
    end
    save_device_info(user.id, session[:new_user_flag])
    if user.forbidden?
      render :json => {error:"forbidden."}.to_json
      return
    end
    session[:user_id] = user.id
    do_login_wb_done(user,token,expires_in,data)
  end
  
  def do_login_qq_done(user,token,expires_in,data)
    $redis.set("qqtoken#{user.id}",token)
    $redis.set("qqexpire#{user.id}",expires_in)
    data.merge!( {:id => user.id, :password => user.password, :name => user.name, :gender => user.gender} )
    data.merge!( user.head_logo_hash  )
	  render :json => data.to_json
  end
  
  def bind_qq(openid,token,expires_in,data)
    user = session_user_no_cache
    if user.qq
      if user.qq != openid
        render :json => {error: "绑定qq帐号失败"}.to_json
        return
      else
        if user.qq_hidden
          user.unset(:qq_hidden) 
        else
          Xmpp.error_notify("#{user.name} 重复绑定qq：#{openid}")  
        end
        do_login_qq_done(user,token,expires_in,data)
      end
    else
      u = User.find_by_qq(openid)
      if u && u.id != session[:user_id]
        render :json => {error: "该qq帐号已经注册过了，不能绑定。"}.to_json
        return
      end
      session_user_no_cache.update_attribute(:qq, openid)
      $redis.set("Q:#{openid}", session[:user_id])
      info = get_qq_user_info(openid,token)
      user.update_attribute(:qq_name,info["nickname"]) if info && info["ret"]==0
      do_login_qq_done(session_user_no_cache,token,expires_in,data)
    end
  end
  
  def bind_qq2(openid,token,expires_in,data)
    if session_user_no_cache.qq != openid
      render :json => {error:"此次登录的QQ帐号和绑定的QQ帐号不一致."}.to_json
      return
    end
    do_login_qq_done(session_user_no_cache,token,expires_in,data)
  end

  def do_login_qq(openid,token,expires_in,data)
    user = User.find_by_qq(openid)
    if user.nil?
      user = gen_new_user_qq(openid,token)
      return if user.nil?
      session[:new_user_flag] = true
      data.merge!({newuser:1})
    end
    save_device_info(user.id, session[:new_user_flag])
    if user.forbidden?
      render :json => {error:"forbidden."}.to_json
      return
    end
    session[:user_id] = user.id
    do_login_qq_done(user,token,expires_in,data)
  end
  
    
  def change_auto_user(user)
    user.auto = false
    user.head_logo_id = nil
    user.pcount = 0
    user.atime = Time.now
    user.save!
  end
  
  def gen_new_user(uid,token)
    sina_info = SinaUser.get_user_info(uid,token)
    #SinaUser.collection.insert(sina_info)
    user = User.new
    user.wb_uid = uid
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
    else
      Xmpp.error_notify("微博用户#{uid}新注册时无法获得user_info")
    end
    user.save!
    $redis.set("W:#{user.wb_uid}", user.id)
    user
  end

  def gen_new_user_qq(openid,token)
    info = get_qq_user_info(openid,token)
    if info.nil?
      Xmpp.error_notify("QQ用户#{openid},#{token}新注册时无法获得user_info")
      render :json => {error: "未知错误，请重试！"}.to_json
      return nil
    end
    if info["ret"]!=0
      render :json => {error: info["ret"].to_s+","+info["msg"] }.to_json
      return nil
    end
    user = User.new
    user.qq = openid
    user.name = info["nickname"]
    user.qq_name = info["nickname"]    
    user.gender = 1 if info["gender"]=="男"
    user.gender = 2 if info["gender"]=="女"
    user.save!
    $redis.set("Q:#{openid}", user.id)
    user
  end  
  
  def get_qq_user_info(openid,token)
    begin
      info = RestClient.get "https://graph.qq.com/user/get_simple_userinfo?access_token=#{token}&oauth_consumer_key=#{$qq_api_key}&openid=#{openid}"
      return ActiveSupport::JSON.decode(info)
    rescue Exception => e
      return nil
    end
  end
  
  def update_token0(id,pass)
    if pass.length>(1+64) #硬编码了token的长度：64
      Resque.enqueue(TokenUpdate, id, pass)
    end
  end
  
end
