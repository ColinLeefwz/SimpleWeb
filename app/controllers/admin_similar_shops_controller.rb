# encoding: utf-8

class AdminSimilarShopsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  
  def index
    hash, sort = {}, {_id: -1}
    case params[:flag]||='2'
    when '1'
      hash.merge!(flag: true)
    when '2'
      hash.merge!(flag: nil)
    when '3'
      hash.merge!(flag: false)
    end
    hash.merge!("data.name" => {"$regex" => params[:name]}) unless params[:name].blank?
    hash.merge!({city: params[:city]}) unless params[:city].blank?
    @similar_shops = paginate3('SimilarShop',params[:page], hash, sort,10 )
  end

  def show
    @similar_shop = SimilarShop.find_by_id(params[:id])
  end

  def ajax_del
    similar_shop = SimilarShop.find_by_id(params[:ssid])
    if ENV["RAILS_ENV"] == "production"
      shop = Shop.find_by_id(params[:sid])
      shop.shop_del
    end

    data = similar_shop.data
    sd = data.detect{|d| d['id'].to_i == params[:sid].to_i}
    sd['type'] = "标记删除"
    similar_shop.set(:data, data)
    expire_cache("SimilarShop#{similar_shop.id}")

    render :json => {}
  end

  def ajax_internal
    similar_shop = SimilarShop.find_by_id(params[:ssid])
    if ENV["RAILS_ENV"] == "production"
      shop = Shop.find_by_id(params[:sid])
      pshop = Shop.find_by_id(params[:msid])
      if pshop
        pshop.shops = pshop.shops.to_a << shop.id.to_i unless pshop.shops.to_a.include?(shop.id.to_i)
        pshop.save
        pshop.merge_subshops_locations
      end
    end
    data = similar_shop.data
    sd = data.detect{|d| d['id'].to_i == params[:sid].to_i}
    sd['type'] = "#{params[:msid]}的内部地点"
    similar_shop.set(:data, data)

    expire_cache("SimilarShop#{similar_shop.id}")
    render :json => {}
  end

  def ajax_merge_del
    similar_shop = SimilarShop.find_by_id(params[:ssid])
    if ENV["RAILS_ENV"] == "production"
      shop = Shop.find_by_id(params[:sid])
      shop.merge_to(params[:msid])
    end

    data = similar_shop.data
    sd = data.detect{|d| d['id'].to_i == params[:sid].to_i}
    sd['type'] = "合并删除至#{params[:msid]}"
    similar_shop.set(:data, data)

    expire_cache("SimilarShop#{similar_shop.id}")
    render :json => {}
  end

  def ajax_cancel
    similar_shop = SimilarShop.find_by_id(params[:ssid])
    similar_shop.set(:flag, true)
    render :json => {}
  end

  def ajax_pause
    similar_shop = SimilarShop.find_by_id(params[:ssid])
    similar_shop.set(:flag, false)
    render :json => {}
  end


  def expire_cache(key)
    Rails.cache.delete(key)
  end


end
