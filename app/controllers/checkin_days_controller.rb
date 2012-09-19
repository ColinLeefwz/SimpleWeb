class CheckinDaysController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  
  def index
    @checkin_days = CheckinDay.where({}).sort({_id: -1}).limit(15)
  end
end
