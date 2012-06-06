class AroundmeController < ApplicationController
  
  def shops
    mshop = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    if params[:lat] && params[:lng]
      lat,lng = Offset.offset(params[:lat].to_f,params[:lng].to_f)      
      mshops = Mshop.paginate(:conditions => genCondition(lat, lng), :order => genOrder(lat, lng), :page => page, :per_page =>pcount )
    end
    render :json => mshops.map {|u| u.safe_output}.to_json
  end
  
  def shops_by_ip
    ret = []
    ip = params[:ip] || real_ip
    Checkin.find_all_by_ip(ip).each do |ckin|
      if ckin.mshop
        ret << ckin.mshop
      else
        shop = Mshop.new
        shop.name = ckin.shop_name
        ret << shop
      end
    end
    render :json => ret[0,100].map {|u| u.safe_output}.to_json
  end

  def users
    ret = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    page = page.to_i
    pcount = pcount.to_i
    logger.info("login user count: #{$login_users.size} ")
    $login_users.each do |id|
      ret << User.find_by_id(id).safe_output
    end
    ret = ret[(page-1)*pcount,pcount]
    if ret
      render :json => ret.to_json
    else
      render :json => [].to_json
    end
  end


  private
  def genCondition(lat, lng)
    return ["mshops.lat < ? and mshops.lat > ? and mshops.lng < ? and mshops.lng > ?", lat+0.005, lat-0.005, lng+0.005, lng-0.005]
  end

  def genOrder(lat, lng)
    return "abs(abs(mshops.lat - #{lat}) + abs(mshops.lng - #{lng}))"
  end
  
end
