class AroundmeController < ApplicationController
  
  def shops
    uid = ",ObjectId('#{session[:user_id]}')" if session[:user_id]
    str = "find_shops([#{params[:lat]},#{params[:lng]}],#{params[:accuracy]},'#{real_ip}'#{uid})"
    arr = Mongoid.default_session.command(eval:str)["retval"]
    hash = arr.map do |x|
      s = Shop.new(x)
      s.id = x["_id"].to_i
      s.safe_output_with_users
    end
    render :json =>  hash.to_json
  end
  
  def mapabc
    count = params[:count] || 100
    loc = Offset.offset(params[:lat].to_f , params[:lng].to_f)
    render :json =>  Mapabc.where({ loc: { "$within" => { "$center" => [loc, 0.003]} }}).limit(count).map {|s| s.safe_output_with_users}.to_json
  end
  
  def shops_by_ip
    ret = []
    render :json => [].to_json    #取消该接口
    return
    ip = params[:ip] || real_ip
    Checkin.where(ip: ip).each do |ckin|
      if ckin.mshop
        ret << ckin.mshop
      else
        shop = Mshop.new
        shop.name = ckin.shop_name
        shop.lat = ckin.loc[0]
        shop.lng = ckin.loc[1]
        ret << shop
      end
    end
    ret.uniq!
    render :json => ret[0,10].map {|s| s.safe_output_with_users}.to_json
  end
  
end
