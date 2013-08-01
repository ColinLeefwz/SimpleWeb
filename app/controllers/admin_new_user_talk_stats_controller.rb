class AdminNewUserTalkStatsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    
    @pl_stat = paginate3("PlStat", params[:page], hash, sort)
  end


end