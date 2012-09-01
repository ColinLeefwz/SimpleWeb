class CouponsController < ApplicationController
  def img
    cp = Coupon.find(params[:id])
    response.headers['IMG_URL'] = cp.img.url
    redirect_to cp.img.url
  end
  
  def use
    Coupon.find(params[:id]).use(session[:user_id])
    render :json => {used: params[:id]}.to_json
  end
  
end
