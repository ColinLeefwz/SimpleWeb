class AdminUserAddShopsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {creator: {"$exists" => true}, t: nil}
    hash.merge!( {name: /#{params[:name]}/ }  )  unless params[:name].blank?
    hash.merge!({city: params[:city]}) unless params[:city].blank?

    @page =  params[:page].blank? ? 1 : params[:page].to_i
    @shops = Shop.where(hash).skip((@page-1)*20).limit(20).sort({_id: -1})


  end

  def show
    @shop = Shop.find_primary(params[:id])
  end

  def baidu_map
    @shop = Shop.find(params[:id])
    @shop.lob = @shop.lo_to_lob
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])
    if @shop.update_attributes(params[:shop])
      redirect_to :action => :show, :id => @shop.id
    else
      render :action => :edit
    end
    
  end

  def del
    @shop = Shop.find(params[:id])
    Del.insert(@shop)
    redirect_to :action => :index
  end

  
end