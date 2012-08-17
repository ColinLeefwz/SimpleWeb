require 'oauth2'

$sina_api_key = "2054816412"  
$sina_api_key_secret = "75487227b4ada206214904bb7ecc2ae1"  
$sina_callback = "http://www.dface.cn/oauth2/sina_callback"

$login_users = [] if $login_users.nil?

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


  def sina_callback
    if params[:code].nil?
      render :json => params.to_json
      return
    end
    @@client ||= sina_client
    token = @@client.auth_code.get_token(params[:code], :redirect_uri => $sina_callback, :parse => :json )
    uid = token.params["uid"]
    data = {:token=> token.token, :expires_in => token.expires_in, :expires_at => token.expires_at, :wb_uid => uid }
    user = User.find_by_wb_uid uid
    if user.nil?
      sina_info = get_user_info(uid,token.token)
      SinaUser.collection.insert(sina_info)
      user = User.new
      user.wb_uid = uid
      user.password = Digest::SHA1.hexdigest(":dface#{user.wb_uid}")[0,16]
      if sina_info
        user.name = sina_info["screen_name"]
        user.gender = 1 if sina_info["gender"]=="m"
        user.gender = 2 if sina_info["gender"]=="f"
      end
      user.save!
    end
    session[:user_id] = user.id
    $login_users << user.id
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
