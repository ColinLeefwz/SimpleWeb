class AdminUserActivesController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  # GET /admins
  # GET /admins.xml
  def index
    if params[:id]
      @user_active = UserActive.find_by_id(params[:id])
    else
     @user_active = UserActive.where({}).sort("$natural" => 1).last
    end
   @ids = UserActive.where({}).sort("$natural" => 1).map{|m| m._id}
  end


end

