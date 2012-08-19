class MshopController < ApplicationController
  require 'open-uri'
  layout nil
  def index
  end
  
  def map1
    @mshop = Mshop.find_by_dp_id(params[:id])
  end

  def map2
    @mshop = Mshop.find_by_dp_id(params[:id])
  end

  def offset
    @latlng = Offset.offset(params['lat'].to_f, params['lng'].to_f)
    render :json => @latlng.to_json
  end

  def antioffset
    @latlng = Offset.antioffset(params['lat'].to_f, params['lng'].to_f)
    render :json => @latlng.to_json
  end

end
