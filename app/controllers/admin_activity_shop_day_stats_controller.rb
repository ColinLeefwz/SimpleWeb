class AdminActivityShopDayStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index

    hash = {}
    sort = {_id: -1}

    @activity_shop_day_stats =  paginate3("ActivityShopDayStat", params[:page], hash, sort, 5)

  end

end