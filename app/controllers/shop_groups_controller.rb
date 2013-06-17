# coding: utf-8

class ShopGroupsController < ApplicationController
  before_filter :shop_authorize, :except => [:mobile]
  before_filter :master_authorize, :only => [:show, :edit, :del, :update]
  include Paginate
  layout 'shop'

  def index
    hash = {admin_sid: session[:shop_id]}
    sort ={_id: -1}
    @groups = paginate("Group", params[:page], hash, sort,10)
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
    group.save
    redirect_to :action => "show", :id => group.id
  end

  def edit
    @group.users = @group.show_users(false)
  end

  def update
    params["group"].merge!({"users" => users(params[:group][:users])})
    @group.update_attributes(params[:group])
    redirect_to :action => "show", :id => @group.id
  end

  def del
    @group.delete
    render :json => {}
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
