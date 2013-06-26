class AdminUserDaysController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    sort = {_id: -1}
    hash = {}
    @user_days = paginate3("UserDay", params[:page], hash, sort)
  end

  def users
    sort = {_id: -1}
    hash = {}
    time = params[:id].to_datetime
    idofbegin = time.to_i.to_s(16).ljust(24,'0')
    idofend = time.end_of_day.to_i.to_s(16).ljust(24,'0')
    hash.merge!({_id: {'$gt' => idofbegin, "$lt" => idofend}})
    hash.merge!({gender: params[:gender].to_i}) if params[:gender]
    @users = paginate('user', params[:page], hash, sort)
  end

  def tojson
    @user_days = UserDay.where(:_id.gte => "1980-1-1")
    respond_to do |format|
      format.html
      format.json  { render :json => @user_days }
    end
  end


end
