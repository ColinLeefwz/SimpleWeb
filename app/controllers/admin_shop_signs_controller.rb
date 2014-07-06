# coding: utf-8
class AdminShopSignsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash ={}
    sort ={:_id => -1}
    if !params[:city].blank? && !params[:shop].blank?
      sids = Shop.where({:name => /#{params[:shop]}/, :city => params[:city]}).only(:_id).map { |m| m._id.to_i.to_s }
      hash.merge!(:sid => {'$in' => sids})
    end

    hash.merge!(:sid => params[:sid].to_i.to_s) unless params[:sid].blank?
    @shop_signs = paginate3("ShopSign", params[:page], hash, sort)
  end

  def new
    @shop_sign = ShopSign.new
  end

  def edit
    @shop_sign = ShopSign.find(params[:id])
  end

  def update
    @shop_sign = ShopSign.find(params[:id])
    if @shop_sign.update_attributes(params[:shop_sign])
      redirect_to :action => :show, :id => @shop_sign.id
    else
      render :action => 'edit'
    end
    
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
    @shop_sign = ShopSign.find_primary(params[:id])
  end
  
end
