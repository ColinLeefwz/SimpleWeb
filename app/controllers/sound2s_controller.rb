class Sound2sController < ApplicationController
  before_filter :user_login_filter

  def create
    p = Sound2.new(params[:sound])
    p.user_id = session[:user_id]
    p.save!
    render :json => p.attributes.to_json
  end
  
  def show
    redirect_to Sound2.img_url(params[:id])
  end

end