# coding: utf-8
class Shop3PassController < ApplicationController
  layout 'shop3'
  before_filter :shop_authorize
  def index
    @shop = session_shop
    if request.post?
      return flash.now[:notice] = "原来的密码输入不正确！" if @shop.password != Digest::SHA1.hexdigest(params[:oldpass])[0,16] 
      return flash.now[:notice] = "密码修改失败,请确保两次密码一致." if params[:shop][:password_confirmation] != params[:shop][:password]
      if @shop.update_attribute(:password, Digest::SHA1.hexdigest(params[:shop][:password])[0,16])
        flash[:notice] = '密码修改成功.'
        return redirect_to '/shop_login/index'
      else
        flash.now[:notice] = '密码修改失败.'
      end
    end
  end

end
