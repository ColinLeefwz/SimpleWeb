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
    if cp.t2==1 && cp.num && cpd.num
      path = cpd.gen_tmp_checkin_coupon_img
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
    coupon_down = CouponDown.find(params[:id][0,24])
    coupon_down.use(session[:user_id],params[:data])
    unless ShopMark.where({sid: coupon_down.sid, uid:  session[:user_id]}).limit(1).first
      $redis.smembers("GROUP#{session[:user_id]}").reverse.each do |gid|
        group = Shop.find_by_id(gid).group
        if ( group && line = group.line)
          if line.partners.to_a.flatten.include?(coupon_down.sid.to_s)
            Xmpp.send_chat($gfuid, session[:user_id], "你在#{coupon_down.shop_name}使用了一张优惠券，体验如何点击下面的链接给个评分吧:http://www.dface.cn/shop_marks/new?sid=#{coupon_down.sid}&uid=#{session[:user_id]}&gid=#{group.id}")
            break
          end
        end
      end
    end

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
