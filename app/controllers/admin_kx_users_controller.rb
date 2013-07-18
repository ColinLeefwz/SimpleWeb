# encoding: utf-8
class AdminKxUsersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    if !params[:name].blank? &&  params[:id].blank?
      ids = KxUser.distinct(:id)
      ids = User.where({_id: {"$in" => ids}, name: /#{params[:name]}/}).only(:_id).distinct(:id)
      hash.merge!({_id: {"$in" => ids}})
    end

    unless params[:id].blank?
      hash.merge!({_id: params[:id]})
    end

    unless params[:real_name].blank?
      hash.merge!({name: /#{params[:real_name]}/})
    end

    unless params[:type].blank?
      hash.merge!({type: params[:type]})
    end


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

