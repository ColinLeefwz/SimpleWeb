class AdminUserHoursController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    sort = {_id: -1}
    hash = {}
    @user_hours = paginate3("UserHour", params[:page], hash, sort)
  end

  def tojson
    @user_hours = UserHour.where({:id.gte => "1990-01-01 12"})
    respond_to do |format|
      format.json
    end
  end

  def linecharts

  end

end