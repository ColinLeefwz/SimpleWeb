class CheckinUserManyController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  
  def index
    sort = {:_id => -1}
    hash = {}
    @checkin_user_manies = paginate3("CheckinUserMany", params[:page], hash, sort)
  end

  def show_user
   @checkin_user_many = CheckinUserMany.find(params[:id])
   data = @checkin_user_many.data.to_a
   @datas = paginate_arr(data, params[:page])
  end
end