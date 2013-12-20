class WebPhotoController < ApplicationController
  
  before_filter :weixin_filter, :only => [:show]
  

  def show
    @photo = Photo.find_by_id(params[:id])
    if @photo.room.to_i == $zwyd
      redirect_to "http://www.dface.cn/zwyd_wish?id=#{params[:id]}"
      return
    end
    if @photo
      @user = @photo.user
      render :file => "/web_photo/show.html"
    else
      redirect_to "/404.html"
    end
  end

end