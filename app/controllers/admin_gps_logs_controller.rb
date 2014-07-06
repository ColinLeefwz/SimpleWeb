class AdminGpsLogsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    hash.merge!({uid: params[:uid]}) unless params[:uid].blank?
    hash.merge!({bssid: params[:bssid]}) unless params[:bssid].blank?
    @gps_logs = paginate3('GpsLog',params[:page], hash, sort,100 )
  end

end

