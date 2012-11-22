# coding: utf-8

class ShopSubshopsController < ApplicationController
  include Paginate
  before_filter :shop_authorize
  layout "shop"
  
  def index
    shop_ids =  paginate_arr(session_shop.shops.to_a, params[:page])
    @shops = Shop.where({:_id => {"$in" => shop_ids}})
  end

  def show
    @shop = Shop.find_by_id(params[:id])
  end
end

