class MenuController < ApplicationController
  before_filter :user_login_filter, :only => [:click]
  before_filter :user_is_session_user, :only => [:click]
  
  def get
    menu = Menu.find_by_id(params[:id])
    return render :json => [].to_json if menu.nil?
    render :json => menu.to_json
  end
  
  def click
    mk = MenuKey.find_by_id(params[:key])
    if mk && mk.shop_id==params[:sid]
      mk.send_to_user(session[:user_id])
    else
      Xmpp.send_gchat2($gfuid,params[:sid],session[:user_id], "出错了！" )
    end
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
