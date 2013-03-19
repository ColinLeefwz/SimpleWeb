# encoding: utf-8

class UserCheckinStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {all: -1}
    @checkin_user_stats =  paginate3("CheckinUserStat", params[:page], hash, sort)
  end

end

