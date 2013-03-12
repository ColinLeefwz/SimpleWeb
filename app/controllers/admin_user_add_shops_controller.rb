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
    @shop.lob = @shop.lo_to_lob.reverse.join(',')
    render :layout => true
  end

  def baidu_map
    @shop = Shop.find(params[:id])
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])
    shop = Shop.new(params[:shop])
    @shop.lob = shop.lob.split(/[,，]/).map { |m| m.to_f  }.reverse
    if @shop.lob.count == 2
      @shop.lo = @shop.lob_to_lo
    end
    @shop.addr = shop.addr
    @shop.name = shop.name
    @shop.t = shop.t
    if @shop.save
      render :json => @shop.attributes.slice('name', 'lo', 'addr').merge('lob' => @shop.lob.to_a.reverse.join(','), 'st' => @shop.show_t)
    else
      render :action => :edit
    end
    
  end

  def del
    @shop = Shop.find(params[:id])
    @shop.shop_del
    render :js => "rmshop('#{@shop.id.to_i}');"
  end

  def ajax_del
    @shop = Shop.find(params[:id])
    @shop.shop_del
    render :js => "window.opener.rmshop('#{@shop.id.to_i}');"
  end

  
end