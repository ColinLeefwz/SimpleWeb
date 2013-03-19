class CheckinLocAccsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"


  def index
    sort = {_id: -1}
    hash = {}
    @checkin_loc_accs = paginate3("CheckinLocAcc", params[:page], hash, sort)
  end
end

