class Photo2sController < ApplicationController
  before_filter :user_login_filter

  def create
    p = Photo2.new(params[:photo])
    p.user_id = session[:user_id]
    p.save!
    render :json => p.output_hash.to_json
  end
  
  def show
    photo = Photo2.find(params[:id])
    if params[:size].to_i==0
      redirect_to photo.img.url
    elsif params[:size].to_i==2
      redirect_to photo.img.url(:t2)
    else
      redirect_to photo.img.url(:t1)
    end
  end

end