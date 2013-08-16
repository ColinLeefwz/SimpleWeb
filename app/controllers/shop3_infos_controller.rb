# coding: utf-8

class Shop3InfosController < ApplicationController
  before_filter :shop_authorize
  layout 'shop3'

  def index
    @shop = Shop.find_primary(session[:shop_id])
  end

  def edit
    @shop = Shop.find_by_id(session[:shop_id])
  end

  def update
    @shop = Shop.find(session[:shop_id])
    @shop.name = params[:name]
    si = ShopInfo.new(params[:shop_info])
    sinfo = @shop.info || ShopInfo.new
    sinfo.addr = si.addr
    sinfo._id = @shop._id
    sinfo.contact = si.contact
    sinfo.phone = si.phone
    sinfo.save
    @shop.save
    redirect_to :action => "index"
  end

end
