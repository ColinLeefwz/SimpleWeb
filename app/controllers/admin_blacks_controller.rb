class AdminBlacksController < ApplicationController

  before_filter :admin_authorize
  layout "admin"

  def index
    @users =  User.where({"blacks.report" => 1}).sort({_id:-1})
  end
  

end
