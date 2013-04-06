class Photo2sController < ApplicationController
  before_filter :user_login_filter

  def create
    p = Photo2.new(params[:photo])
    p.user_id = session[:user_id]
    p.save!
    render :json => p.output_hash.to_json
  end
  
  def show
    if params[:size].to_i==0
      redirect_to Photo2.img_url(params[:id])
    else
      redirect_to Photo2.img_url(params[:id],:t2)
    end
  end

end