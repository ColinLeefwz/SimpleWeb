class AdminCrashLogsController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  include Paginate
  # GET /admins
  # GET /admins.xml
  def index
    hash, sort = {}, {_id: -1}
    @crash_logs = paginate3("CrashLog", params[:page], hash, sort  )
  end

  def show
    @crash_log_hash = CrashLog.find_by_id(params[:id]).attributes
    @crash_log_hash.delete("_id")
  end
  
end

