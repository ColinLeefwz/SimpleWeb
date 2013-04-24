# coding: utf-8

class ShopController < ApplicationController

  layout nil
  caches_action :info, cache_path: ->(c) {"SI#{c.params[:id]}"}
  
  def nearby
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    lo = [params[:lat].to_f , params[:lng].to_f]
    city = Shop.get_city(lo)
    hash = {city: city}
    if params[:name]
      hash.merge!( {name: /#{params[:name]}/ }  )  
    else
      hash.merge!( { del:{"$exists"=>false} }  )  
    end
    if params[:type]
      t = params[:type].to_i*2-1
      hash.merge!( {t: { "$in" => [ t-1, t ] } }  ) 
    end
    shops = Shop.where(hash).sort({utotal:-1}).skip(skip).limit(pcount)
    if city=="0571"
      shops = shops.to_a
      shops=shops[1..-1] << shops[0]  if shops[0]["_id"]==20325453
    end
    render :json =>  shops.map {|s| s.safe_output_with_users}.to_json
  end
  
  #签到时输入地点名称查找地点
  def add_search
    if params[:sname].nil? || params[:sname].length>4
      render :json => [].to_json
      return
    end
    lo = [params[:lat].to_f, params[:lng].to_f]
    radis = 0.001 + params[:sname].length*0.0005
    shops = Shop.where({lo:{"$within" => {"$center" => [lo,radis]}}, name:/#{params[:sname]}/}).limit(10)
    render :json =>  shops.map {|s| {id:s.id,name:s.name} }.to_json
  end

  
  def users
    shop = Shop.find_by_id(params[:id])
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    users = shop.users(session[:user_id],(page-1)*pcount,pcount)
    render :json => users.to_json
  end
  
  def info
    shop = Shop.find_by_id(params[:id])
    render :json => shop.safe_output_with_staffs.to_json
  end
  
  def photos
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 5 if pcount==0
    skip = (page-1)*pcount
    photos = shop_photo_cache(params[:id], skip, pcount)
    render :json => photos.map {|p| p.output_hash_with_username }.to_json
  end
  
  def shop_photo_cache_key(sid,skip,pcount)
    "SP#{sid}-#{pcount}"
  end
  
  def shop_photo_cache(sid,skip,pcount)
    if skip>0
      return shop_photo_no_cache(sid,skip,pcount)
    end
    Rails.cache.fetch(shop_photo_cache_key(sid,skip,pcount)) do
      shop_photo_no_cache(sid,skip,pcount)
    end
  end
  
  def shop_photo_no_cache(sid,skip,pcount)
    Photo.where({room:params[:id]}).sort({updated_at: -1}).skip(skip).limit(pcount).to_a
  end


end
