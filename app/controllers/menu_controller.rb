class MenuController < ApplicationController
  before_filter :user_login_filter, :only => [:click]
  before_filter :user_is_session_user, :only => [:click]
  
  def get
    menu = Menu.find_by_id(params[:id])
    return render [].to_json if menu.nil?
    render :json => menu.to_json
  end
  
  def click
    mk = MenuKey.find_by_id(params[:key])
    Xmpp.send_gchat2("s#{params[:sid]}",params[:sid],session[:user_id],"收到key：#{mk.content}") if mk
    render :json => {ok:1}.to_json
  end
  
  def create
    menu = Menu.new
    menu._id = params[:id].to_i 
    menu.button = JSON.parse(params[:button])
    menu.save
  end
  
  def delete
  end
  
  
end
