class ShopController < ApplicationController

  layout nil
  
  def nearby
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    lo = [params[:lat].to_f , params[:lng].to_f]
    hash = {city:"0571"}
    hash.merge!( {name: /#{params[:name]}/ }  )  if params[:name]
    hash.merge!( {t: params[:type].to_i }  )  if params[:type]
    shops = Shop.where(hash).order_by([:utotal,:desc]).skip(skip).limit(pcount)
    render :json =>  shops.map {|s| s.safe_output_with_users}.to_json
  end
  
  def users
    str="shop_users(#{params[:id]})"
    hash = Mongoid.default_session.command(eval:str)["retval"]
    ret = []
    hash.each do |k,v|
      u = User.find2(k[10..-3]) # ObjectId("k") => k
      next if u.block?(session[:user_id])
      ret << u.safe_output_with_relation(session[:user_id])
        .merge!({time:Checkin.time_desc(v)})
    end
    render :json => ret.to_json
  end
  
  def info
    shop = Shop.find(params[:id])
    render :json => shop.safe_output_with_users.to_json
  end


end
