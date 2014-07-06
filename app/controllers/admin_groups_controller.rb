# encoding: utf-8
class AdminGroupsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    @groups =  paginate3("Group", params[:page], hash, sort)
  end

  def new
    @group = Group.new
  end

  def create
    group = Group.new(params[:group])
    group.save
    group.gen_shop(city: params[:city], sid: params[:sid])
    group.zadd_redis_shop_name
    redirect_to :action => :show, :id => group.id
  end

  def edit
    @group = Group.find_by_id(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      @group.shop.update_attributes({name: @group.name, city: params[:city]})
      redirect_to :action => :show, :id => @group.id
    else
      render :action => :edit
    end
  end

  def show
    @group = Group.find_primary(params[:id])
  end

  def users
    @group = Group.find_primary(:params[:id])
    @users = User.where({id: {'$in' => $redis.smembers("group#{@group.sid}")}})
  end


  def invaild
    group = Group.find_by_id(params[:id])
    group.invalidate_old
    group.update_attribute(:invaildt, 2)
    render :json => {}
  end


end

