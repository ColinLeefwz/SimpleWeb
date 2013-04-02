class AdminShopCouponsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  
  def index
    hash = {}
    sort = {}
    if !params[:shop].blank? && !params[:city].blank?
      sids = Shop.where({name: /#{params[:shop]}/, city: params[:city]}).map { |m| m._id  }
      hash.merge!(shop_id: {'$in' => sids})
    end
    #id 必须在name后面, 因为给定id 前面的name就会覆盖。
    hash.merge!({shop_id: params[:sid].to_i}) unless params[:sid].blank?
    

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
    case params[:type]
    when 'use'
      users = @coupon.use_users
    when 'down'
      users = @coupon.down_users
    end
    @users = paginate_arr(users, params[:page],20 )
  end

  def ajax_lapse
    coupon = Coupon.find(params[:id])
    coupon.deply
    render :json => ''
  end
end
