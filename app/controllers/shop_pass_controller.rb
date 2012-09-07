# coding: utf-8
class ShopPassController < ApplicationController
  before_filter :shop_authorize
  def index
    if request.post?
      return flash.now[:notice] = " 原来的密码输入不正确！ " if session_shop.password != params[:oldpass]
      if session_shop.update_attributes(params[:shop])
        flash[:notice] = '密码修改成功.'
        return redirect_to '/shop_login/index'
      end
    end
  end

end
