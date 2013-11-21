class MobileBannersController < ApplicationController
  before_filter :shop_authorize

  layout "mobile"

  def index
 
  end

  def new
    @mobile_banner = MobileBanner.new(params[:mobile_banner])
    @mobile_banners = MobileBanner.where({sid:session[:shop_id]}).sort({_id: -1})
  end

  def create
    @mobile_banner = MobileBanner.new(params[:mobile_banner])
    @mobile_banner.sid = session[:shop_id]

    if @mobile_banner.save
      redirect_to "/mobile_banners/new"
    else
      render :action => "new"
    end
  end

  def ajax_del
    @mobile_banner = MobileBanner.find_by_id(params[:id])
    @mobile_banner.destroy
  end

end