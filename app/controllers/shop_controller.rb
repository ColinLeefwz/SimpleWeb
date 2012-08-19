class ShopController < ApplicationController

  layout nil
  
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
    cs = Checkin.where({shop_id:params[:id].to_i}).sort({_id:-1}).limit(100)
    hash = cs.map{|c| c.user.safe_output_with_relation(session[:user_id]).merge!({time:c.time_desc})}
    render :json => hash.to_json
  end


end
