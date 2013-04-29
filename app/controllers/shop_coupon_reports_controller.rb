# encoding: utf-8
class ShopCouponReportsController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    date = params[:date] || Time.now.to_date
    coupon_downs = CouponDown.where({sid: session[:shop_id], dat: {"$gte" => date}}).only(:cid, :uat)
    @report = coupon_downs.group_by{|g| g.coupon}.map{|x,y| [x,y.count, y.count{|c| c.uat}]}
  end


end