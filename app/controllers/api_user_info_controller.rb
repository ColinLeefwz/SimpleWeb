class ApiUserInfoController < ApplicationController

  def basic
    if params[:session]
      cache = $redis.get(params[:session])
      user_id = Marshal.load(cache)["user_id"] unless cache.blank?
    else
      user_id = params[:id]
    end
    user = User.find_by_id(user_id)
    render json: user.safe_output.to_json
  end
end