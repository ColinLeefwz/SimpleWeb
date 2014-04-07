class AdminShopCouponsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  
  def index
    hash = {}
    sort = {_id: -1}
    if !params[:shop].blank? && !params[:city].blank?
      sids = Shop.where({name: /#{params[:shop]}/, city: params[:city]}).map { |m| m._id  }
      hash.merge!(shop_id: {'$in' => sids})
    end
    #id 必须在name后面, 因为给定id 前面的name就会覆盖。
    hash.merge!({shop_id: params[:sid].to_i}) unless params[:sid].blank?

    hash.merge!({name: /#{params[:name]}/}) unless params[:name].blank?

    case params[:t2]
    when '1'
      hash.merge!({ t2: 1})
    when '2'
      hash.merge!({ t2: 2})
    end
    

    case params[:hidden]
    when '1'
      hash.merge!({hidden: 1})
    when nil
      hash.merge!({hidden: nil})
    end

    @coupons = paginate3("Coupon", params[:page], hash, sort)
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    @coupon = Coupon.find(params[:id])
  end

  def detail
    @coupon = Coupon.find(params[:id])
    hash = {cid: @coupon.id}
    sort = {}
    case params[:type]
    when 'use'
      hash.merge!({uat: {'$exists' => true}})
      sort.merge!({uat: -1, dat: -1})
    when 'down'
      sort.merge!({dat: -1})
    end
    @coupon_downs = paginate3("CouponDown", params[:page],hash, sort )

  end
  
  def sendto
    @coupon = Coupon.find(params[:id])
    user = User.find_by_id(params[:user_id])
    if @coupon.send_coupon(user.id)
      render :text => "#{@coupon.name}成功发送给#{user.name}"
    else
      render :text => "#{@coupon.name}发送失败"      
    end
  end

  def ajax_lapse
    coupon = Coupon.find(params[:id])
    coupon.deply
    render :json => ''
  end

  def ajax_destroy
    coupon = Coupon.find(params[:id])
    coupon.down_users.each{|d| Del.insert(d)}
    Del.insert(coupon)
    render :json => ''
  end
end
