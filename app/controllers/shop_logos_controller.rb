class ShopLogosController < ApplicationController
  before_filter :shop_authorize
  layout 'shop'
  
  def index
    if params[:id]
      @shop_logo = ShopLogo.find_primary(params[:id])
    else
      @shop_logo = ShopLogo.shop_logo(session[:shop_id])
    end
  end

  def new
    @shop_logo = ShopLogo.new
  end

  def create
    @shop_logo = ShopLogo.shop_logo(session[:shop_id])
    if @shop_logo
      @shop_logo.update_attributes(params[:shop_logo])
    else
      @shop_logo=  ShopLogo.new(params[:shop_logo])
      @shop_logo.shop_id = session[:shop_id]
      @shop_logo.save
      Rails.cache.write("HAS_LOGO#{session[:shop_id]}", true)
    end
    redirect_to :action => :index, :id => @shop_logo.id
  end
end
