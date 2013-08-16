class Sound2sController < ApplicationController
  before_filter :user_login_filter, :only => [:uptoken]
  before_filter :user_is_session_user, :only => [:uptoken]
  
  def uptoken
    token = Sound2.uptoken(params[:user_id])
    render :json => {token:token }.to_json
  end
  
  def callback
    #TODO: 判断调用来自七牛
    snd = Sound2.new
    snd._id = params[:id]
    snd.sec = params[:sec]
    user = User.find_by_id(params[:from])
    snd.user_id = user.id
    snd.to_uid = params[:to]
    snd.save!
    snd.after_async_store
    render :json => request.params.to_json
  end

  def show
    redirect_to "http://sound.qiniudn.com/#{params[:id]}"
  end

end