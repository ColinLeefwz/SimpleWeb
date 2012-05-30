require 'oauth2'

$sina_api_key = "2054816412"  
$sina_api_key_secret = "75487227b4ada206214904bb7ecc2ae1"  

class Oauth2Controller < ApplicationController
  
  def hello
    render :text => "hello"
  end
  
  def sina_client
    client = OAuth2::Client.new('2054816412','75487227b4ada206214904bb7ecc2ae1',:site => 'https://api.weibo.com/')
    client.options[:authorize_url] = "/oauth2/authorize"
    client.options[:token_url] = "/oauth2/access_token"
    client
  end

  def sina_new
    @@client ||= sina_client
    #render :text => 
    redirect_to @@client.auth_code.authorize_url(:redirect_uri => 'http://www.dface.cn/oauth2/sina_callback')
  end


  def sina_callback
    token = @@client.auth_code.get_token(params[:code], :redirect_uri => 'http://www.dface.cn/oauth2/sina_callback', :parse => :json )
    debugger
    data = {:token=> token.token, :expires_in => token.expires_in, :expires_at => token.expires_at, :sina_uid => token.params["uid"] }
	  render :json => data.to_json
  end
  
end
