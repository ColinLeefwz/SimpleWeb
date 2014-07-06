# encoding: utf-8
class AdminMobileShopsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    ids = $redis.smembers('MobileShops')
    @mobile_shops =  ids.map{|m| Shop.find_by_id(m)}.compact
  end

  def destory
    $redis.srem("MobileShops", params[:id])
    respond_to do |format|
      format.html { redirect_to :action => "index"}
      format.json { render json: {} }
    end
  end

  def new

  end
  
  def create
    $redis.sadd("MobileShops", params[:id])
    shop = Shop.find_by_id(params[:id])
    shop.set(:mweb, true)
    respond_to do |format|
      format.html { redirect_to :action => "index"}
      format.json { render json: {} }
    end
  end

end

