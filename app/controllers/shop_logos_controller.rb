class ShopLogosController < ApplicationController
  before_filter :shop_authorize
  layout 'shop'
  
  def index
    @shop_logo = ShopLogo.shop_logo(session[:shop_id])
  end

  def new
    @shop_logo = ShopLogo.new
  end

  def create
    @shop_logo=  ShopLogo.new(params[:shop_logo])
    @shop_logo.shop_id = session[:shop_id]
    if @shop_logo.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end
end
