class CouponsController < ApplicationController
  def img
    cp = Coupon.find(params[:id])
    response.headers['IMG_URL'] = cp.avatar.url
    send_file cp.avatar.path
  end
  
  def use
    Coupon.find(params[:id]).use(session[:user_id])
    render :json => {used: params[:id]}.to_json
  end
  
end
