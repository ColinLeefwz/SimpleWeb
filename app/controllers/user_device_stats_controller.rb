class UserDeviceStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  # GET /coupons
  # GET /coupons.json
  def index
    hash, sort = {}, {_id: -1}
    @user_device_stats =  paginate3("UserDeviceStat", params[:page], hash, sort)
  end
 
end
