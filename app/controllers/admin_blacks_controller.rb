class AdminBlacksController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    @users = paginate3("User", params[:page], {"blacks.report" => 1}, {_id:-1})
  end
  

end
