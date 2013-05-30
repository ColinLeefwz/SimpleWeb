# coding: utf-8
class ShopPassController < ApplicationController
  layout 'shop'
  before_filter :shop_authorize
  def index
    @shop = session_shop
    if request.post?
      return flash.now[:notice] = "原来的密码输入不正确！" if @shop.password != params[:oldpass]
      return flash.now[:notice] = "密码修改失败,请确保两次密码一致." if params[:shop][:password_confirmation] != params[:shop][:password]
      if @shop.update_attribute(:password, params[:shop][:password])
        flash[:notice] = '密码修改成功.'
        return redirect_to '/shop_login/index'
      else
        flash.now[:notice] = '密码修改失败.'
      end
    end
  end

end
