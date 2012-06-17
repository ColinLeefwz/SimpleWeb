class MshopController < ApplicationController
  require 'open-uri'
  layout nil
  def index
  end
  
  def nearby
    mshops = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    if params[:lat] && params[:lng]
      lat,lng = Offset.offset(params[:lat].to_f,params[:lng].to_f)      
      mshops = Mshop.paginate(:conditions => genCondition(lat, lng), :order => genOrder(lat, lng), :include => :mcategories, :page => page, :per_page =>pcount )
    end
    render :json => mshops.map {|u| u.safe_output}.to_json
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
    respond_to do |format|
      format.js {render :json => @latlng.to_json}
    end
  end

  def antioffset
    @latlng = Offset.antioffset(params['lat'].to_f, params['lng'].to_f)
    respond_to do |format|
      format.js {render :json => @latlng.to_json}
    end
  end

  private
  def genCondition(lat, lng)
    sql = "mshops.lat < ? and mshops.lat > ? and mshops.lng < ? and mshops.lng > ?"
    a = [lat+0.1, lat-0.1, lng+0.1, lng-0.1]


    unless params[:name].blank?
      sql += " and mshops.name like ? "
      a << "%#{params[:name]}%"
    end

    unless params[:mcategory_id].blank?
      sql += " and mcategories.id = ?"
      a << params[:mcategory_id]
    end
    
    return a.unshift(sql)

    #    return ["mshops.lat < ? and mshops.lat > ? and mshops.lng < ? and mshops.lng > ?", lat+0.1, lat-0.1, lng+0.1, lng-0.1]
  end

  def genOrder(lat, lng)
    return "abs(abs(mshops.lat - #{lat}) + abs(mshops.lng - #{lng}))"
  end

end
