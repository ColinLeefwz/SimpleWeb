# coding: utf-8

class ZwydWishController < ApplicationController

  before_filter :photo_authorize
  def create
    return render :index if params[:name].blank? || params[:wish].blank?
    @zwyd_wish.total += 1
    @zwyd_wish.data << [params[:name], params[:wish]]
    @zwyd_wish.save
    return render :text => "祝福成功"
  end

  def photo_authorize
    @zwyd_wish = ZwydWish.find_by_id(params[:id])
    return render :text => "无效图片" if @zwyd_wish.nil?
  end

end

