# coding: utf-8

class ShopInternalCouponsController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    hash = {sid: {"$in" => session_shop.shops.to_a }}

    if !params[:name].blank?
      sids  = Shop.where({_id: {"$in" => session_shop.shops.to_a }, name: params[:name]}).distinct(:id)
      hash.merge!({sid: {"$in" => sids }})
    end

    if !params[:day].blank?
      bd = params[:day].to_datetime
      ed = bd.end_of_day
      hash.merge!({dat: {"$gte" => bd-8.hours, "$lte" => ed-8.hours}})
    end

    sort ={_id:  -1}
    @downs =  paginate("CouponDown", params[:page], hash, sort)
  end


end
