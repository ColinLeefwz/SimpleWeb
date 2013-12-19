# coding: utf-8

class ZwydWishController < ApplicationController

  before_filter :photo_authorize, :except => [:list]
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


  def list
    if params[:skip]
     zwyd_wishs = ZwydWish.where({}).limit(3).skip(params[:skip]).sort({_id: -1})
     data = zwyd_wishs.map{|m| ["photo_url" => "http://www.dface.cn/zw#{m.id}.jpg", 'user_logo' => m.user_logo, 'user_name' => m.photo_user.try(:name), 'photo_desc' => m.photo_desc, 'total' => m.total.to_i ]}
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: data.to_json }
    end
  end


end

