class AdminFoodsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    shops = $redis.zrevrange('FOODSHOPS', 0, -1)
    @shops = paginate_arr(shops, params[:page]).map{|m| Shop.find_by_id(m)}
  end

  def delete
    $redis.zrem('FOODSHOPS', params[:id])
    redirect_to :action => :index
  end

  def new
    
  end

  def create
    shop = Shop.find_by_id(params[:id])
    if shop
      $redis.zadd('FOODSHOPS', Time.now.to_i, params[:id])
      redirect_to :action => :index
    else
      render :action => :new
    end

  end


end
