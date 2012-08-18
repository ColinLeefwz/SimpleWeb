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
      response.headers['IMG_URL'] = photo.avatar.url
      send_file photo.avatar.path
    elsif params[:size].to_i==2
      response.headers['IMG_URL'] = photo.avatar.url(:thumb2)
      send_file photo.avatar.path(:thumb2)
    else
      response.headers['IMG_URL'] = photo.avatar.url(:thumb)
      send_file photo.avatar.path(:thumb)
    end
  end

end