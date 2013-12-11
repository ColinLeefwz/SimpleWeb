class WebPhotoController < ApplicationController

  def show
  	
    @photo = Photo.find_by_id(params[:id])
    if @photo
      @user = @photo.user
      render :file => "/web_photo/show.html"
    else
      redirect_to "/404.html"
    end
    
  end

end