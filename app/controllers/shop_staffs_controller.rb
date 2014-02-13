# encoding: utf-8
class ShopStaffsController < ApplicationController
  include Paginate
  before_filter :shop_authorize
  layout "shop"


  def index
    hash = {:shop_id => session_shop.id}
    sort = {}
    @staffs =  paginate('staff', params[:page], hash, sort, 10)
  end

  def new
    staff_ids = Staff.where({shop_id: session_shop.id}).map{|s| s.user_id}
    checkin = Checkin.where({sid: session_shop.id}).sort_by{|s| s.id}.group_by{|g| g.uid}
    @users = (checkin.keys - staff_ids ).reverse.map{|m| User.find_by_id(m) }
    @users = paginate_arr(@users, params[:page], 10)
  end

  def ajax_add_staff
    user = User.find_by_id(params[:id])
    if user.is_staff?(session[:shop_id])
      text = "已是员工"
    else
      staff = Staff.new({user_id: user.id, shop_id: session_shop.id})
      text =  staff.save ? "添加成功" : "添加失败"
    end
    Rails.cache.delete("STF#{session_shop.id}")
    render :json => {:text => text }.to_json
  end

  def ajax_delete_staff
    staff = Staff.find_by_id(params[:id])
    staff.destroy if staff
    Rails.cache.delete("STF#{session_shop.id}")
    render :json => {:text => '删除成功'}
  end
  
end
