class AdminUsersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index

    hash = {}
    sort = {_id: -1}

    unless params[:name].blank?
      hash.merge!(name: /#{params[:name]}/)
    end

    hash.merge!({id: params[:id]}) unless params[:id].blank?
    hash.merge!({wb_uid: params[:wb_uid]}) unless params[:wb_uid].blank?

    @users =  paginate("User", params[:page], hash, sort)


  end

  def show
    @user = User.find(params[:id])
  end

  def chat
    @user = User.find(params[:id])
    chats = @user.chat.sort{|a,b| b[2] <=> a[2]}
    @chats = paginate_arr(chats, params[:page], 50)
  end

  def human_chat
    @user = User.find(params[:id])
    chats = @user.human_chat(params[:uid]).sort{|a,b| b[3] <=> a[3]}
    @chats =paginate_arr(chats, params[:page], 50 )
  end
  
  def kill
    @user = User.find(params[:id])
    @user.password=nil
    @user.save!
    RestClient.post("http://#{$xmpp_ip}:5280/api/kill", :user => params[:id]) 
    render :text => "ok"
  end
  
  def unkill
    @user = User.find(params[:id])
    @user.password=Digest::SHA1.hexdigest(":dface#{@user.wb_uid}")[0,16]
    @user.save!
    render :text => "ok"
  end

end

