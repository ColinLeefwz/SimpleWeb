# coding: utf-8

class ShopGroupsController < ApplicationController
  before_filter :shop_authorize, :except => [:mobile, :twocode, :intro]
  before_filter :master_authorize, :only => [ :edit, :del, :update,:checkins, :show]
  include Paginate
  layout 'shop'

  def intro
    @group = Group.find_by_id(params[:id])
    @line = @group.line
    render :layout => false
  end

  def twocode
    @group = Group.find_by_id(params[:id])
    render :layout => false
  end

  def index
    hash = {admin_sid: session[:shop_id]}
    sort ={_id: -1}
    @groups = paginate("Group", params[:page], hash, sort,10)
  end

  def show
    @group = Group.find_primary(params[:id])
  end

  def new
    @group = Group.new
  end

  def mobile
    @group = Group.find_by_id(params[:id])
    #    @group = Group.last
    @line = @group.line
    render :layout => false
  end

  def create
    group = Group.new(params[:group])
    group.admin_sid = session[:shop_id]
    group.users = users(group.users)
    group.gen_shop
    group.save
    group.reload.bat_phone_auth
    group.create_shop_faq
    redirect_to :action => "show", :id => group.id
  end

  def edit
    #    @group.users = @group.show_users(false)
  end

  def update
    params["group"].merge!({"users" => users(params[:group][:users])})
    @group.update_attributes(params[:group])
    @group.reload.bat_phone_auth
    redirect_to :action => "show", :id => @group.id
  end


  def del
    @group.delete
    render :json => {}
  end

  def checkins
    hash,sort = {},{_id: -1}
    uids = @group.users.map{|m| m['id']}
    scid = @group.fat.beginning_of_day.to_i.to_s(16).ljust(24,'0')
    ecid = @group.tat.end_of_day.to_i.to_s(16).ljust(24,'0')
    hash.merge!({uid: {"$in" => uids}})
    hash.merge!({_id: {"$gt" => scid, "$lt" => ecid}})
    @checkins = paginate("Checkin", params[:page], hash, sort,10)
  end

  private
  def master_authorize
    @group = Group.find(params[:id])
    render :text => "该旅行团不是您的，你无权操作！" if @group.admin_sid.to_i != session[:shop_id].to_i
  end

  def users(stru)
    stru.split("\r\n").map do |m|
      arr = m.split(/[,，]/).map{|m| m.strip}
      hash={}
      hash.merge!({name: arr[0]}) unless arr[0].blank?
      hash.merge!({phone: arr[1]}) unless arr[1].blank?
      hash.merge!({sfz: arr[2]}) unless arr[2].blank?
      hash.merge!({id: arr[3]}) unless arr[3].blank?
      hash
    end
  end



end
