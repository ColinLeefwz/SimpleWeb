class MshopController < ApplicationController
  require 'open-uri'
  layout nil
  def index
  end
  
  def nearby
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    loc = Offset.offset(params[:lat].to_f , params[:lng].to_f)
    hash = { loc: { "$within" => { "$center" => [loc, 0.1]} }}
    hash.merge!( {name: /#{params[:name]}/ }  )  if params[:name]
    hash.merge!( {t: params[:type].to_i }  )  if params[:type]
    shops = Shop.where(hash).skip(skip).limit(pcount)
    render :json =>  shops.map {|s| s.safe_output_with_users}.to_json
  end
  
  def users
    shop = Mshop.find(params[:id])
    render :json => shop.users.map {|u| u.safe_output_with_relation(session[:user_id])}.to_json
  end
  
  
  def map1
    @mshop = Mshop.find_by_dp_id(params[:id])
  end

  def map2
    @mshop = Mshop.find_by_dp_id(params[:id])
  end

  def offset
    @latlng = Offset.offset(params['lat'].to_f, params['lng'].to_f)
    render :json => @latlng.to_json
  end

  def antioffset
    @latlng = Offset.antioffset(params['lat'].to_f, params['lng'].to_f)
    render :json => @latlng.to_json
  end

end
