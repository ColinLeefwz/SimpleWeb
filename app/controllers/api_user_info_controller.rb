class ApiUserInfoController < ApplicationController

  def basic
    user = User.find_by_id(params[:id])
    render json: user.safe_output.to_json
  end
end