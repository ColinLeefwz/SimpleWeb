# coding: utf-8

class Shop3DataController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout "shop3"

  def index
    @shop_downed_week = Coupon.shop_downed_week(session[:shop_id])
    @shop_downed_week_num = Coupon.shop_downed_week(session[:shop_id]).count()

    @shop_use_week = Coupon.shop_use_week(session[:shop_id])
    @shop_use_week_num = Coupon.shop_use_week(session[:shop_id]).count()

    @shop_checkin_week = Coupon.shop_checkin_week(session[:shop_id])
    @shop_checkin_week_num = Coupon.shop_checkin_week(session[:shop_id]).count()

  end

end