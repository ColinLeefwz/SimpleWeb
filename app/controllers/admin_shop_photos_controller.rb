# coding: utf-8
class AdminShopPhotosController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash ={}
    sort ={:_id => -1}

    if !params[:city].blank? && !params[:shop].blank?
      sids = Shop.where({:name => /#{params[:shop]}/, :city => params[:city]}).only(:_id).map { |m| m._id.to_i.to_s }
      hash.merge!(:room => {'$in' => sids})
    end

    hash.merge!(:room => params[:sid].to_i.to_s) unless params[:sid].blank?
    hash.merge!(:user_id => params[:user_id]) unless params[:user_id].blank?

    @photos = paginate3("Photo", params[:page], hash, sort)
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def ajax_del
    photo = Photo.find(params[:id])
    photo.update_attribute(:hide, true)
    expire_cache_shop(photo.room)
    render :json => {:text => '隐藏成功'}
  end

  def ajax_undel
    photo = Photo.find(params[:id])
    photo.unset(:hide)
    expire_cache_shop(photo.room)
    render :json => {:text => '显示成功'}
  end

  def hide_com
    photo = Photo.find(params[:id])
    result = photo.hidecom(params[:uid], params[:t])
    expire_cache_shop(photo.room)
    render :json => {:text => result ? 0 : 1 }
  end

  def unhide_com
    photo = Photo.find(params[:id])
    result = photo.unhidecom(params[:uid], params[:t])
    expire_cache_shop(photo.room)
    render :json => {:text => result ? 0 : 1 }
  end

  private
  def expire_cache_shop(sid)
    Rails.cache.delete("SP#{sid}-5")
  end
end
