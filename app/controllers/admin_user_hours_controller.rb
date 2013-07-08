class AdminUserHoursController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    sort = {_id: -1}
    hash = {}
    @user_hours = paginate3("UserHour", params[:page], hash, sort)
  end

end