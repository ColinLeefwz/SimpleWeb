# encoding: utf-8
class AdminCoUsersController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    if !params[:name].blank? &&  params[:id].blank?
      ids = CoUser.distinct(:id)
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


    @co_users =  paginate3("CoUser", params[:page], hash, sort)
  end

  def destory
    co_user = CoUser.find(params[:id])
    $redis.srem("CoUsers", co_user.id)
    co_user.delete
    redirect_to :action => "index"
  end
 
  def edit
    @co_user = CoUser.find_by_id(params[:id])
  end
  
  def update
    @co_user = CoUser.find(params[:id])
    @co_user.update_attributes(params[:co_user])
    redirect_to :action => "index"
  end

  def create_co
    @cu = CoUser.new(params[:co_user])
    @cu._id = params[:id].__mongoize_object_id__
    if @cu.save
      $redis.sadd("CoUsers", @cu._id)
      redirect_to :action => :index
    else
      render :new
    end
  end

end

