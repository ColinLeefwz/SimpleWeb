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

  def user_statistics
    ck = Checkin.where({sid:session[:shop_id]})
    gender = ck.map{|m| m.user.gender}.group_by{|g| g}.map{|k,v| [k,v.count]}.sort
    if gender.size < 3
      female = gender[1][1]
      male = gender[0][1]
    elsif gender.size == 3
      female = gender[2][1]
      male = gender[1][1]
    end
    ago = ck.map{|m| m.user.birthday.to_s[0,4].to_i}.group_by{|g| g}.map{|k,v| [k.to_i,v.count]}
    ago6 = ago.map{|m| m[1] if m[0]>2000 || m[0]<1970}.compact.inject{|a,b| a+b}
    ago5 = ago.map{|m| m[1] if m[0]>=1990 && m[0]<=2000}.compact.inject{|a,b| a+b}
    ago4 = ago.map{|m| m[1] if m[0]>=1985 && m[0]<1990}.compact.inject{|a,b| a+b}
    ago3 = ago.map{|m| m[1] if m[0]>=1980 && m[0]<1985}.compact.inject{|a,b| a+b}
    ago2 = ago.map{|m| m[1] if m[0]>=1975 && m[0]<1980}.compact.inject{|a,b| a+b}
    ago1 = ago.map{|m| m[1] if m[0]>=1970 && m[0]<1975}.compact.inject{|a,b| a+b}
    back = ck.map{|m| m.uid}.uniq.count
    sum = ck.map{|m| m}.count
    render :text => [male,female,ago1,ago2,ago3,ago3,ago4,ago5,ago6,back,sum]
  end
end