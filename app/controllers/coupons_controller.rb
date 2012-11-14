# coding: utf-8

class CouponsController < ApplicationController
  before_filter :user_login_filter, :only => :use

  def img
    cp = Coupon.find(params[:id][0,24])
      if params[:size].to_i==0
        redirect_to cp.img.url
      else
        redirect_to cp.img.url(:t1)
      end
  end
  
  def use
    Coupon.find(params[:id][0,24]).use(session[:user_id])
    render :json => {used: params[:id]}.to_json
  end
  
end
