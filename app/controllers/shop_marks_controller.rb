# coding: utf-8
class ShopMarksController < ApplicationController
  layout false
  before_filter :com_authorize
  
  def new
  end

  def create
    @shop_mark = ShopMark.new
    @shop_mark.sid = params[:sid]
    @shop_mark.uid = params[:uid]
    @shop_mark.gid = params[:gid] unless params[:gid].blank?
    @shop_mark.mark = params[:mark]
    @shop_mark.com = params[:com]
    @shop_mark.com_at = Time.now
    @shop_mark.save
    render :text => "已评价"
  end

  def  com_authorize
    @user = User.find_by_id(params[:uid])
    @shop = Shop.find_by_id(params[:sid])
    @group = Group.find_by_id(params[:gid])
   
    if @user.nil?  || @shop.nil?
      render :text => "不可评论"
    end

    if @group
      render :text => "你不是此旅行团的成员" unless @group.users.find{|u| u['id'] == params[:uid]}
      render :text => "此商家不是本次旅行团的合作商家" unless @group.line.partners.values.flatten.include?(params[:sid])
    end

  end

end
