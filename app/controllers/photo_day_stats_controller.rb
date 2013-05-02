class PhotoDayStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  # GET /coupons
  # GET /coupons.json
  def index
    hash, sort = {}, {_id: -1}
    @photo_day_stats =  paginate3("PhotoDayStat", params[:page], hash, sort, 10)
  end
 
end
