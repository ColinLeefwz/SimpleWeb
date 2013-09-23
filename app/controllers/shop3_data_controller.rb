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

  def down_json
    hash = {sid: session[:shop_id]}
    unless params[:name].blank?
      uids = User.where(:name => /#{params[:name]}/).only(:_id).map { |m| m._id }
      hash.merge!({uid: {'$in' => uids}})
    end
    hash.merge!({uid: params[:uid]}) unless params[:uid].blank?
    
    sort = {_id: -1}
    @downs = paginate2("CouponDown", params[:page], hash, sort, 10000)
    respond_to do |format|
      format.json
    end
  end

  def use_json
    hash = {sid: session[:shop_id]}
    unless params[:name].blank?
      uids = User.where(:name => /#{params[:name]}/).only(:_id).map { |m| m._id }
      hash.merge!({uid: {'$in' => uids}})
    end
    hash.merge!({uid: params[:uid]}) unless params[:uid].blank?
    
    sort = {_id: -1}
    @uses = paginate2("CouponDown", params[:page], hash, sort, 10000)
    respond_to do |format|
      format.json
    end
  end

end