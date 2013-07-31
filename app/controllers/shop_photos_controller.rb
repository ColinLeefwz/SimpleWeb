# coding: utf-8

class ShopPhotosController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    hash = {:room => session[:shop_id].to_i.to_s}
    hash.merge!({user_id: params[:uid]}) unless params[:uid].blank?
    sort = {:od => -1, :updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,10)
  end

  def ajax_del
    photo = Photo.find(params[:id])
    photo.update_attribute(:hide, true)
    expire_cache_shop(photo.room)
    render :json => {:text => '已隐藏'}
  end

  def ajax_undel
    photo = Photo.find(params[:id])
    photo.unset(:hide)
    expire_cache_shop(photo.room)
    render :json => {:text => "已取消"}
  end

  def ajax_top
    photo = Photo.find(params[:id])
    od = Photo.where({room: session[:shop_id].to_s}).max(:od).to_i+1
    photo.set(:od, od)
    render :json => {}
  end

  def ajax_untop
    photo = Photo.find(params[:id])
    photo.unset(:od)
    render :json => {}
  end

  def show
    @photo = Photo.find_by_id(params[:id])
  end

  def show_like
    @photo = Photo.find_by_id(params[:id])
    @likes = paginate_arr(@photo.like.to_a, params[:page])
  end

  def show_com
    @photo = Photo.find_by_id(params[:id])
    @coms = paginate_arr(@photo.com.to_a.reject{|p| p["hide"]}, params[:page])
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
    Rails.cache.delete("views/SI#{sid}.json")
  end

end
