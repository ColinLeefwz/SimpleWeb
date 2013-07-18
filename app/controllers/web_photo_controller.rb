class WebPhotoController < ApplicationController

  def show
    @photo = Photo.find(params[:id])
    @user = User.find(@photo.user_id)
    @userlogo = UserLogo.where(user_id:@user.id).first
  end

end