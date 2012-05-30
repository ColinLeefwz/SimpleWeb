class AroundmeController < ApplicationController
  
  def shops
    lat,lng = Offset.offset(params[:lat].to_f,params[:lng].to_f)
    mshops = []
    if lat != 0 && lng != 0
      mshops = Mshop.paginate(:conditions => genCondition(lat, lng), :order => genOrder(lat, lng), :page => params[:page], :per_page =>10)
    end
    respond_to do |format|
      format.json {render :json => mshops.to_json}
      format.html {render :json => mshops.to_json}
    end
  end

  def users
    ret = []
    logger.info("login user count: #{$login_users.size} ")
    $login_users.each do |id|
      user = User.find_by_id(id)
      uh = {:id => user.id, :sina_uid => user.wb_uid, :logo => '/phone2/images/namei2.gif'}
      ret << uh
    end
    render :json => ret.to_json
  end


  private
  def genCondition(lat, lng)
    return ["mshops.lat < ? and mshops.lat > ? and mshops.lng < ? and mshops.lng > ?", lat+0.005, lat-0.005, lng+0.005, lng-0.005]
  end

  def genOrder(lat, lng)
    return "abs(abs(mshops.lat - #{lat}) + abs(mshops.lng - #{lng}))"
  end
  
end
