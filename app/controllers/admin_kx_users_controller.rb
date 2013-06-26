# encoding: utf-8
class AdminKxUsersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    @kx_users =  paginate3("KxUser", params[:page], hash, sort)
  end

  def destory
    kx_user = KxUser.find(params[:id])
    $redis.srem("KxUsers", kx_user.id)
    kx_user.delete
    redirect_to :action => "index"
  end
 
  def edit
    @kx_user = KxUser.find(params[:id])
  end
  
  def update
    @kx_user = KxUser.find(params[:id])
    @kx_user.update_attributes(params[:kx_user])
    redirect_to :action => "index"
  end

end

