class AdminUserCityDaysController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    sort = {_id: -1}
    hash = {}
    @user_city_days = paginate3("UserCityDay", params[:page], hash, sort)
  end



end
