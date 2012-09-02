class CouponsController < ApplicationController
  def img
    cp = Coupon.find(params[:id])
    
    if params[:size].to_i==0
      redirect_to cp.img.url
    else
      redirect_to cp.img.url(:t1)
    end
  end
  
  def use
    Coupon.find(params[:id]).use(session[:user_id])
    render :json => {used: params[:id]}.to_json
  end
  
end
