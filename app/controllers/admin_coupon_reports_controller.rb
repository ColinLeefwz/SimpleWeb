class AdminCouponReportsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  
  def index
    hash = {}
    sort = {_id: -1}
    if !params[:city].blank? && !params[:shop].blank?
      sids = Shop.where({city: params[:city], name: /^#{params[:shop]}/}).only(:_id).distinct(:_id)
      hash.merge!(sid: {"$in" => sids})
    end
    hash.merge!(sid: params[:sid].to_i) if !params[:sid].blank?
    hash.merge!(cid: params[:cid]) if !params[:cid].blank?
    if !params[:uname].blank?
      uid = User.where({name: /#{params[:uname]}/}).only(:_id).distinct(:_id)
      hash.merge!(uid: {"$in" => uid})
    end

    case params[:isu]
    when '1'
      hash.merge!({uat: nil})
    when '2'
      hash.merge!({uat: {"$exists" => true}})
    end
    hash.merge!(uid: params[:uid]) if !params[:uid].blank?
    @coupon_downs = paginate3("CouponDown", params[:page], hash, sort)
  end



end
