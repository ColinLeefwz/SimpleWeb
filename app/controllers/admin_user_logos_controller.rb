class AdminUserLogosController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index

    hash = {}
    sort = {_id: -1}

    @users =  paginate3("User", params[:page], hash, sort, 40)

  end

end
