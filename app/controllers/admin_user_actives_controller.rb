class AdminUserActivesController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  # GET /admins
  # GET /admins.xml
  def index
    if params[:id]
      @user_active = UserActive.find_by_id(params[:id])
    else
      @user_active = UserActive.last
    end
   
  end


end

