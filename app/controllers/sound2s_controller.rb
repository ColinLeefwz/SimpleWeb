class Sound2sController < ApplicationController
  #before_filter :user_login_filter
  
  def uptoken
    token = Sound2.uptoken(params[:user_id])
    render :json => {token:token }.to_json
  end
  
  def callback
    snd = Sound2.new
    #snd._id = params[:key]
    snd.sec = params[:sec]
    snd.save!
    snd.after_async_store
    render :json => request.params.to_json
  end

  def show
    redirect_to "http://sound.qiniudn.com/#{params[:id]}"
  end

end