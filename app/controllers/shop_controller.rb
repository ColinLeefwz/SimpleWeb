# coding: utf-8

class ShopController < ApplicationController

  layout nil
  caches_action :info, cache_path: ->(c) {"SI#{c.params[:id]}"}
  caches_action :photos, cache_path: ->(c) {"SP#{c.params[:id]}-#{c.params[:pcount]}#{c.params[:page]}"}
  
  
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
  
  def users
    shop = Shop.find_by_id(params[:id])
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    users = shop.users(session[:user_id],(page-1)*pcount,pcount)
    if users.nil?
      render :json => [].to_json
      return
    end
    fm = users.group_by {|item| item["gender"]==2 ? "f" : "m" }
    fmf = fm["f"]
    fmf = [] if fmf.nil?
    fmm = fm["m"]
    fmm = [] if fmm.nil?
    render :json => fmf.concat(fmm).to_json
  end
  
  def info
    shop = Shop.find_by_id(params[:id])
    render :json => shop.safe_output_with_staffs.to_json
  end
  
  def photos
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    photos = Photo.where({room:params[:id]}).sort({updated_at: -1}).skip(skip).limit(pcount)
    render :json => photos.map {|p| p.output_hash_with_username }.to_json
  end

end
