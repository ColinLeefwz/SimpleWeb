# encoding: utf-8
class Shop3StaffsController < ApplicationController
  include Paginate
  before_filter :shop_authorize
  layout "shop3"


  def index
    hash = {:shop_id => session_shop.id}
    sort = {}
    @staffs =  paginate('staff', params[:page], hash, sort, 10)
  end

  def new
    staff_ids =Staff.where({shop_id: session[:shop_id]}).distinct(:user_id)
    checkin_uids = Checkin.where({sid: session[:shop_id]}).distinct(:uid)
    uids = paginate_arr((checkin_uids-staff_ids),params[:page], 10)
    @users = User.find_by_id(uids)
  end

  def ajax_add_staff
    user = User.find_by_id(params[:id])
    if user.is_staff?(session[:shop_id])
      text = "已是员工"
    else
      staff = Staff.new({user_id: user.id, shop_id: session_shop.id})
      $redis.sadd("STAFF#{user.id}",session_shop.id)
      text =  staff.save ? "添加成功" : "添加失败"
    end
    Rails.cache.delete("STF#{session_shop.id}")
    render :json => {:text => text }.to_json
  end

  def ajax_delete_staff
    staff = Staff.find_by_id(params[:id])
    staff.destroy if staff
    $redis.srem("STAFF#{staff.user_id}",session_shop.id)
    Rails.cache.delete("STF#{session_shop.id}")
    render :json => {:text => '删除成功'}
  end
  
end
