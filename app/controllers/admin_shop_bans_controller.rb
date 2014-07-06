class AdminShopBansController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {}
    if !params[:city].blank? && !params[:shop].blank?
      sids = Shop.where({:name => /#{params[:shop]}/, :city => params[:city]}).only(:_id).map { |m| m._id.to_i.to_s }
      hash.merge!(:_id => {'$in' => sids})
    end

    hash.merge!(:_id => params[:sid].to_i.to_s) unless params[:sid].blank?
    
    @shop_bans = paginate3("ShopBan", params[:page], hash, sort)
  end

  def show
    @shop = Shop.find(params[:id])
  end
end