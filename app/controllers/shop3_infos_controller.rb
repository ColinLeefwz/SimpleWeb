# coding: utf-8

class Shop3InfosController < ApplicationController
  before_filter :shop_authorize
  layout 'shop3'

  def index
    @shop = Shop.find_primary(session[:shop_id])

    if params[:id]
      @shop_logo = ShopLogo.find_primary(params[:id])
    else
      @shop_logo = ShopLogo.shop_logo(session[:shop_id])
    end

  end

  def edit
    @shop = Shop.find_by_id(session[:shop_id])
  end

  def update
    @shop = Shop.find(session[:shop_id])
    @shop.name = params[:name]
    if params[:shop_info]
      shop_info = @shop.info || ShopInfo.new
      shop_info._id = @shop._id
      shop_info.save
      shop_info.update_attributes(params[:shop_info])
    end 
    if params[:shop_logo]
      @shop_logo = @shop.logo || ShopLogo.new
      @shop_logo.shop_id = session[:shop_id]
      @shop_logo.save
      @shop_logo.update_attributes(params[:shop_logo])
      Rails.cache.write("HAS_LOGO#{session[:shop_id]}", true)
    end
    @shop.save
    redirect_to :action => "index"
  end

end
