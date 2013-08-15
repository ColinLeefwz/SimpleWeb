class Sound2sController < ApplicationController
  before_filter :user_login_filter
  
  def uptoken
    token = Sound2.uptoken(params[:user_id])
    render :json => {token:token }.to_json
  end
  
  def callback
    Sound2.callback
    render :json => {sec:params[:sec]}.to_json
  end

  def show
    redirect_to Sound2.img_url(params[:id])
  end

end