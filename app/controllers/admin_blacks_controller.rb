class AdminBlacksController < ApplicationController

  before_filter :admin_authorize
  layout "admin"

  def index
    @users =  User.where({"blacks.report" => 1})
  end
  

end
