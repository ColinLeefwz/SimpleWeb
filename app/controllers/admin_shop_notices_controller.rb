class AdminShopNoticesController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  
  def index
    hash = {}
    sort = {}
    unless params[:shop].blank? && params[:city].blank?
      sids = Shop.where({name: /#{params[:shop]}/, city: params[:city]}).map { |m| m._id  }
      hash.merge!(shop_id: {'$in' => sids})
    end
    #id 必须在name后面, 因为给定id 前面的name就会覆盖。
    hash.merge!({shop_id: params[:sid].to_i}) unless params[:sid].blank?
    
    hash.merge!({id: params[:id].to_i}) unless params[:id].blank?
    @shop_notices = paginate3("ShopNotice", params[:page], hash, sort)
  end

  def show
    @shop = Shop.find(params[:shop_id])
    @shop_notices = ShopNotice.show_notices(params[:shop_id], 3)
  end
end