class AdminBssidStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {}
    hash.merge!({_id: params[:bssid]}) unless params[:bssid].blank?
    @bssid_stats = paginate3("CheckinBssidStat", params[:page], hash, sort)
  end

end