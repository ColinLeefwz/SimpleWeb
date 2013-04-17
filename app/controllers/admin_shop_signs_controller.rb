# coding: utf-8
class AdminShopSignsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash ={}
    sort ={:_id => -1}
    @shop_signs = paginate3("ShopSign", params[:page], hash, sort)
  end

  def new
    @shop_sign = ShopSign.new
  end

  def edit
    @shop_sign.find(params[:id])
    
  end

  def create
    @shop_sign = ShopSign.new(params[:shop_sign])
    if @shop_sign.save
      redirect_to :action => :show, :id => @shop_sign.id
    else
      render :action => :new
    end
  end

  def show
    @shop_sign.find_primany(params[:id])
  end
  
end
