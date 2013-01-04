# coding: utf-8

require 'oauth2'
require 'rest_client'


$sina_api_key = "2054816412"  
$sina_api_key_secret = "75487227b4ada206214904bb7ecc2ae1"  
$sina_callback = "http://www.dface.cn/oauth2/sina_callback"

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
    data = {:token=> token.token, :expires_in => token.expires_in, :expires_at => token.expires_at, :wb_uid => uid }
    do_login(uid,token.token,data)
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
    data = {:token=> token["access_token"], :expires_in => token["expires_in"], :expires_at => token["expires_at"], :wb_uid => uid }
    do_login(uid,token["access_token"],data)
  end
  
  def logout
    if params[:pushtoken] && session_user.token==params[:pushtoken]
      session_user.unset(:tk)
    end
    reset_session
    render :json => {"logout" => true}.to_json
  end

  def share
    Resque.enqueue(WeiboFirst, $redis.get("wbtoken#{user_id}") )
    render :json => {"shared" => true}.to_json
  end  
  


  #提供给erlang系统的认证服务
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
      user = User.find2(params["name"])
      if user.password == pass
	logger.warn "token:#{ptoken}"
        User.collection.find({_id:user._id}).update("$set" => {tk:ptoken}) if user.tk.nil? && ptoken
        render :text => "1"
        return
      end
    end
    render :text => "0"
  end
  
  def push_msg_info
    logger.warn "params['from'],params['to']"
    fu = User.find2(params["from"])
    tu = User.find2(params["to"])
    if fu && tu
      render :text => "#{tu.tk}#{fu.name}"
    else
      render :text => ""
    end
  end
  
  private
  
  def do_login(uid,token,data)
    user = User.where({wb_uid: uid}).first
    if user.nil?
      sina_info = get_user_info(uid,token)
      SinaUser.collection.insert(sina_info)
      user = User.new
      user.wb_uid = uid
      user.password = Digest::SHA1.hexdigest(":dface#{user.wb_uid}")[0,16]
      if sina_info
        user.name = sina_info["screen_name"]
        user.gender = 1 if sina_info["gender"]=="m"
        user.gender = 2 if sina_info["gender"]=="f"
        user.wb_v = sina_info["verified"]
        user.wb_vs = sina_info["verified_reason"]
      end
      user.save!
    end
    session[:user_id] = user.id
    $redis.set("wbtoken#{user.id}",token)
    data.merge!( {:id => user.id, :password => user.password, :name => user.name, :gender => user.gender} )
    data.merge!( user.head_logo_hash  )
	  render :json => data.to_json
  end
  
  def get_user_info(uid,token)
    require 'open-uri'
    url = "https://api.weibo.com/2/users/show.json?uid=#{uid}&source=#{$sina_api_key}&access_token=#{token}"
    
    open(url) do |f|
      return ActiveSupport::JSON.decode( f.gets )
    end
    return nil
  end
  
end
