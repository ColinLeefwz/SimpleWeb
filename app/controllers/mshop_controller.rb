class MshopController < ApplicationController
  require 'open-uri'
  layout nil
  def index
  end

  # 根据latlng获取周围商家，10 per
  def aroundme
    lat,lng = Offset.offset(params[:lat].to_f,params[:lng].to_f)
    mshops = []
    if lat != 0 && lng != 0
      mshops = Mshop.paginate(:conditions => genCondition(lat, lng), :order => genOrder(lat, lng), :page => params[:page], :per_page =>10)
    end
    respond_to do |format|
      format.js {render :json => mshops.to_json}
    end
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
    return ["mshops.lat < ? and mshops.lat > ? and mshops.lng < ? and mshops.lng > ?", lat+0.005, lat-0.005, lng+0.005, lng-0.005]
  end

  def genOrder(lat, lng)
    return "abs(abs(mshops.lat - #{lat}) + abs(mshops.lng - #{lng}))"
  end

end
