class WebPhotoController < ApplicationController

  def show
    @photo = Photo.find_by_id(params[:id])
    @user = @photo.user
    @userlogo = @user.head_logo #TODO:参考head_logo_hash
  end

end