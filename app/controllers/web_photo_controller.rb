class WebPhotoController < ApplicationController

  def show
  	
    @photo = Photo.find_by_id(params[:id])
    if @photo
      @user = @photo.user
      respond_to do |format|
        format.html { render :layout => false}
        format.json { render :json => @user }
      end
    else
      redirect_to "/404.html"
    end
    
  end

end