# coding: utf-8

class ZwydWishController < ApplicationController

  def create
    zwyd_wish = ZwydWish.find_by_id(params[:id])
    return render :text => "无效图片" if zwyd_wish.nil?
    return render :index if params[:name].blank? || params[:wish].blank?
    data = zwyd_wish.data
    data[:total] += 1
    data[params[:name]] = params[:wish]
    zwyd_wish.set(:data, data)
  end

end

