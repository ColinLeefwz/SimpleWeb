# encoding: utf-8
class AdminWUsersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    if !params[:name].blank? &&  params[:id].blank?
      ids = WUser.distinct(:id)
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


    @w_users =  paginate3("WUser", params[:page], hash, sort)
  end

  def destory
    w_user = WUser.find(params[:id])
    $redis.srem("WUsers", w_user.id)
    w_user.delete
    redirect_to :action => "index"
  end
 
  def edit
    @w_user = WUser.find_by_id(params[:id])
  end
  
  def update
    @w_user = WUser.find(params[:id])
    @w_user.update_attributes(params[:w_user])
    redirect_to :action => "index"
  end

end

