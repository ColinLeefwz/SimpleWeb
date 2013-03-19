class AdminShopLogosController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {}
    hash.merge!({_id: params[:sid].to_i}) unless params[:sid].blank?

    unless params[:shop].blank? && params[:city].blank?
      hash.merge!({name: /#{params[:shop]}/, city: params[:city]})
    end
    
    @shop_logos = paginate3("ShopLogo", params[:page], hash, sort)
  end

  def show
    @shop = Shop.find(params[:id])
  end
end