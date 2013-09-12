# coding: utf-8

class Shop3InternalReportController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout "shop3"

  def index
    hash, sort ={sid: session[:shop_id]}, {day: -1}
    if params[:sday] && params[:eday]
      hash.merge!({day: {"$gte" => params[:sday], "$lte" =>  params[:eday] }})
    end
    @reports = paginate("InternalCouponStat", params[:page], hash, sort,20)
  end


  def show
    @report = InternalCouponStat.find_by_id(params[:id])
  end

end