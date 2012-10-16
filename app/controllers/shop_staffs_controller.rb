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

  def ajax_add_staff
    user = User.find2(params[:id])
    if user.is_staff?
      text = "已是员工"
    else
      staff = Staff.new({user_id: user.id, shop_id: session_shop.id})
      text =  staff.save ? "添加成功" : "添加失败"
    end
    render :json => {:text => text }.to_json
  end

  def ajax_delete_staff
    staff = Staff.find_by_id(params[:id])
    staff.delete if staff
    render :json => {:text => '删除成功'}
  end
  
end
