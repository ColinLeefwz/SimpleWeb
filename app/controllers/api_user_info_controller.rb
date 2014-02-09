class ApiUserInfoController < ApplicationController

  def basic
    if !params[:session].blank?
      cache = $redis.get(params[:session])
      user_id = Marshal.load(cache)["user_id"] unless cache.blank?
    else
      user_id = params[:id]
    end
    user = User.find_by_id(user_id)
    render json: user.safe_output.to_json
  end
  
  def in_shop
    return render text: false if params[:uid].nil? || params[:sid].to_i==0
    flag = User.in_shop(params[:uid],params[:sid])
    render text: flag
  end
  
end