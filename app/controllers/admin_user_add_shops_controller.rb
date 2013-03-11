# encoding: utf-8
class AdminUserAddShopsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {creator: {"$exists" => true}}
     
    case params[:t].to_s
    when ''
      hash.merge!({t: nil})
    when '1'
      hash.merge!({t: {"$exists" => true}})
    end

    case params[:del].to_s
    when ''
      hash.merge!({del: {"$exists" => false}})
    when '1'
      hash.merge!({del: 1})
    end
    hash.merge!({})
    hash.merge!( {name: /#{params[:name]}/ }  )  unless params[:name].blank?
    hash.merge!({city: params[:city]}) unless params[:city].blank?
    @page =  params[:page].blank? ? 1 : params[:page].to_i
    @shops = Shop.where(hash).skip((@page-1)*10).limit(10).sort({_id: -1})
  end

  def show
    @shop = Shop.find_primary(params[:id])
    @shop.lob = @shop.lo_to_lob
  end

  def baidu_map
    @shop = Shop.find(params[:id])
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])
    @shop.lob = @shop.lob.split(/[,，]/).map { |m| m.to_f  }.reverse
    if @shop.lob.count == 2
      params[:shop][:lo] = @shop.lob_to_lo
    end
    if @shop.update_attributes(params[:shop])
      redirect_to :action => :show, :id => @shop.id
    else
      render :action => :edit
    end
    
  end

  def del
    @shop = Shop.find(params[:id])
    shop.shop_del
    redirect_to :action => :index
  end

  
end