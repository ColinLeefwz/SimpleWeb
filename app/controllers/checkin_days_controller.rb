class CheckinDaysController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  
  def index
    hash = {}
    sort = {_id: -1}
    @checkin_days = paginate3("CheckinDay", params[:page], hash, sort  )
  end
end
