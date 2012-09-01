class PhotosController < ApplicationController
  before_filter :user_login_filter

  def create
    p = Photo.new(params[:photo])
    p.user_id = session[:user_id]
    p.save!
    render :json => p.output_hash.to_json
  end
  
  def show
    photo = Photo.find(params[:id])
    if params[:size].to_i==0
      response.headers['IMG_URL'] = photo.img.url
      redirect_to photo.img.url
    elsif params[:size].to_i==2
      response.headers['IMG_URL'] = photo.img.url(:t2)
      redirect_to photo.img.url(:t2)
    else
      response.headers['IMG_URL'] = photo.img.url(:t1)
      redirect_to photo.img.url(:t1)
    end
  end

end