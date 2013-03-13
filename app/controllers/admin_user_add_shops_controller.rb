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
    @shop = Shop.find_by_id(params[:id])
    @shop.lob = @shop.lo_to_lob.reverse.join(',')
    render :layout => true
  end

  #  def baidu_map
  #    @shop = Shop.find(params[:id])
  #  end
  #
  #  def edit
  #    @shop = Shop.find(params[:id])
  #  end

  def update
    @shop = Shop.find(params[:id])
    shop = Shop.new(params[:shop])
    unless shop.lob.blank?
      lobs = shop.lob.split(/[;；]/)
      @shop.lob = lobs.inject([]){|f,s| f << s.split(/[,，]/).map { |m| m.to_f  }.reverse}
      @shop.lo = @shop.lob.map{|m| Shop.lob_to_lo(m)}
    else
      shop.lob = @shop.lo_to_lob.reverse.join(',')
    end
    @shop.addr = shop.addr
    @shop.name = shop.name
    @shop.t = shop.t
    if @shop.save
      pshop = Shop.find_by_id(params[:pid])
      if pshop
        pshop.shops = pshop.shops.to_a << @shop.id.to_i unless pshop.shops.include?(@shop.id.to_i)
        pshop.save
        pshop.merge_subshops_locations
      end
      render :json => @shop.attributes.slice('name', 'lo', 'addr').merge('lob' => shop.lob, 'st' => @shop.show_t)
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

  def ajax_dis
    lob1 = params[:lob1].split(/[,，]/).map { |m| m.to_f  }.reverse
    lob2 = params[:lob2].split(/[,，]/).map {|m| m.to_f }.reverse
    distance = Shop.new.get_distance(lob1, lob2)
    render :json => {:distance => distance}
  end

  def near
    @shop = Shop.find_by_id(params[:id])
    shops = Shop.where({:lo => {"$within" => {"$center" => [@shop.lo, 0.03]}},:name => /#{@shop.name}/,:_id => {"$ne" => @shop.id }})
    data = shops.map{|shop| [ shop.id.to_i, shop.name,  shop.addr,  shop.show_t,  shop.min_distance(shop, @shop.lo)]}
    render :json => data
  end
end