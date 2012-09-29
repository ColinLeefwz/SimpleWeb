class AdminUsersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"
  
  def index
    
    hash = {}
    sort = {}

    @users =  paginate("User", params[:page], hash, sort)


  end

  def show
    @user = User.find(params[:id])
  end
  
end