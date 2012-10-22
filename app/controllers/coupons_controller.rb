class CouponsController < ApplicationController
  def img
    cp = Coupon.find(params[:id])
    if cp.desc == "测试券" #测试优惠券在本地，不上传的阿里云
      if params[:size].to_i==0
        redirect_to "/#{cp._id}.jpg"
      else
        redirect_to "/#{cp._id}.jpg_2.jpg"
      end
    else
      if params[:size].to_i==0
        redirect_to cp.img.url
      else
        redirect_to cp.img.url(:t1)
      end
    end


  end
  
  def use
    Coupon.find(params[:id]).use(session[:user_id])
    render :json => {used: params[:id]}.to_json
  end
  
end
