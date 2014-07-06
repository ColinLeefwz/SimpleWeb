# encoding: utf-8
class AdminWuserShopsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    ids = $redis.smembers('CoShops')
    @co_shops =  ids.map{|m| Shop.find_by_id(m)}.compact
  end

  def destory
    $redis.srem("CoShops", params[:id])
    respond_to do |format|
      format.html { redirect_to :action => "index"}
      format.json { render json: {} }
    end
  end

  def new

  end
  
  def create
    $redis.sadd("CoShops", params[:id])
    respond_to do |format|
      format.html { redirect_to :action => "index"}
      format.json { render json: {} }
    end
  end

end

