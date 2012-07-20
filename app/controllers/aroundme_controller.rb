class AroundmeController < ApplicationController
  
  def shops
    count = params[:count] || 10
    render :json =>  Shop.where({ loc: { "$near" => [params[:lat].to_i , params[:lng].to_i]}}).limit(count).map {|s| s.safe_output_with_users}.to_json
  end
  
  def shops_by_ip
    ret = []
    ip = params[:ip] || real_ip
    Checkin.find_all_by_ip(ip).each do |ckin|
      #TODO: 去重复
      if ckin.mshop
        ret << ckin.mshop
      else
        shop = Mshop.new
        shop.name = ckin.shop_name
        shop.lat = ckin.lat
        shop.lng = ckin.lng
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
