# coding: utf-8
class ShopMarksController < ApplicationController
  before_filter :com_authorize,:only => [:new, :create]
  before_filter :shop_authorize, :only => [:index]
  include Paginate
  layout 'shop'
  
  
  def index
    hash = {:sid => session[:shop_id]}
    sort = {_id: -1}
    @shop_marks = paginate("ShopMark", params[:page], hash, sort,10)
  end


  def new
    render :layout =>false
  end

  def create
    shop_mark = ShopMark.new
    shop_mark.sid = params[:sid]
    shop_mark.uid = params[:uid]
    shop_mark.gid = params[:gid] unless params[:gid].blank?
    shop_mark.admin_sid = @group.admin_sid
    shop_mark.mark = params[:mark]
    shop_mark.com = params[:com]
    shop_mark.save
    render :text => "已评价", :layout =>false
  end

  def  com_authorize
    render :text => "已评过，不可以再评" if ShopMark.where({sid: params[:sid], uid: params[:uid]}).limit(1).first
    user = User.find_by_id(params[:uid])
    @shop = Shop.find_by_id(params[:sid])
    group = Group.find_by_id(params[:gid])
    render :text => "不可评价" if user.nil?  || @shop.nil?
    if group
      @group = group
      render :text => "你不是此旅行团的成员" unless group.users.find{|u| u['id'] == params[:uid]}
      render :text => "此商家不是本次旅行团的合作商家" unless group.line.partners.values.flatten.include?(params[:sid])
    end
  end

end
