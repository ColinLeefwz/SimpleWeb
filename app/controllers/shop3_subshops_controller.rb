# encoding: utf-8
class Shop3SubshopsController < ApplicationController
  include Paginate
  before_filter :shop_authorize
  layout "shop3"


  def index
    @shops = Shop.where({:_id => {"$in" => paginate_arr(session_shop.shops.to_a, params[:page])}})
  end

  
  
end
