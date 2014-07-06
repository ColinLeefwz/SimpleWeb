# coding: utf-8
class AdminUserDayActivesController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    sort = {_id: -1}
    hash = {}
    @user_days_active = paginate3("UserDayActive", params[:page], hash, sort)
  end

end