class AroundmeController < ApplicationController
  
  def shops
    str = "find_shops([#{params[:lat]},#{params[:lng]}])"
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

  def users
    ret = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    page = page.to_i
    pcount = pcount.to_i
    logger.info("login user count: #{$login_users.size} ")
#    $login_users.each do |id|
#      ret << User.find_by_id(id).safe_output_with_relation(session[:user_id])
#    end
    User.where("name is not null").order("id asc").limit(50).each {|u| ret << u.safe_output_with_relation(session[:user_id])}
    ret = ret[(page-1)*pcount,pcount]
    if ret
      render :json => ret.to_json
    else
      render :json => [].to_json
    end
  end
  
end
