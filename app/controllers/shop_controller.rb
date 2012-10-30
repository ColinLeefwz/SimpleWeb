class ShopController < ApplicationController

  layout nil
  
  def nearby
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    str = "nearby_shops([#{params[:lat]},#{params[:lng]}],#{page},#{pcount}"
    if params[:name]
      str << ",#{params[:type].to_i},/#{params[:name]}/)"
    elsif params[:type]
      str << ",#{params[:type]})"
    else
      str << ")"
    end
    arr = Mongoid.default_session.command(eval:str)["retval"]
    hash = arr.map do |x|
      s = Shop.new(x)
      s.id = x["_id"].to_i
      s.safe_output_with_users
    end
    render :json =>  hash.to_json
  end
  
  def users
    shop = Shop.find(params[:id])
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    render :json => shop.users(session[:user_id],(page-1)*pcount,pcount).to_json
  end
  
  def info
    shop = Shop.find(params[:id])
    render :json => shop.safe_output_with_staffs.to_json
  end


end
