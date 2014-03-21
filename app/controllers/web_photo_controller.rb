class WebPhotoController < ApplicationController
  
  before_filter :weixin_filter, :only => [:show]
  

  def show
    @photo = Photo.find_by_id(params[:id])
    if @photo.room.to_i == $zwyd
      redirect_to "http://www.dface.cn/zwyd_wish?id=#{params[:id]}"
      return
    end
    if @photo
      agent = request.env["HTTP_USER_AGENT"].downcase
      @user = @photo.user
      if agent.index("iphone") || agent.index("ipad") || agent.index("android") || agent.index("mobile")
        render :file => "/web_photo/show.mobile", :layout => false
      else
        render :file => "/web_photo/show.html", :layout => false
      end
    else
      redirect_to "/404.html"
    end
  end

end