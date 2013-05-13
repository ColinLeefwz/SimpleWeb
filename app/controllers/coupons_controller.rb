# coding: utf-8

class CouponsController < ApplicationController
  before_filter :user_login_filter, :only => :use

  def img
    cpd = CouponDown.find(params[:id][0,24])
    cp = cpd.coupon
    if cpd.uid != session[:user_id]
      render :json => {error: "你没有获取到过这张优惠券"}.to_json
      return
    end
    if cp.t2==2 && cp.img.url.nil?
      path = cpd.gen_share_coupon_img
      redirect_to path
      return
    end
    if params[:size].to_i==0
      redirect_to cp.img.url
    else
      redirect_to cp.img.url(:t1)
    end
  end

  def delivered
    cp = CouponDown.find(params[:id][0,24])
    cp.update_attribute(:sat, Time.now) unless cp.sat
    render :json => {recv: params[:id]}.to_json
  end

  def displayed
    cp = CouponDown.find(params[:id][0,24])
    cp.update_attribute(:vat, Time.now) unless cp.vat
    render :json => {display: params[:id]}.to_json
  end
      
  def use
    CouponDown.find(params[:id][0,24]).use(session[:user_id],params[:data])
    render :json => {used: params[:id]}.to_json
  end
  
  def info
    hash = params[:ids].split(",").map do |id|
      cd = CouponDown.find_by_id(id)
      #raise "优惠券拥有者错误" if cd.uid != session[:user_id]
      shop = cd.shop
      {id:id, loc: shop.loc_first}
    end
    render :json => hash.to_json
  end
  
end
