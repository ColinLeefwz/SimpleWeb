# coding: utf-8
class ShopPassController < ApplicationController
  before_filter :shop_authorize
  def index
    @shop = session_shop
    if request.post?
      return flash.now[:notice] = " 原来的密码输入不正确！ " if @shop.password != params[:oldpass]
      if @shop.update_attributes(params[:shop])
        flash[:notice] = '密码修改成功.'
        return redirect_to '/shop_login/index'
      end
    end
  end

end
