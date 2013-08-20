# coding: utf-8

class Shop3ContentController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop3'

  def user_photo
    hash = {:room => session[:shop_id].to_i.to_s}
    hash.merge!({user_id: params[:uid]}) unless params[:uid].blank?
    sort = {:od => -1, :updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,15)
  end

  def shop_photo

  end

  def show_photo
    @photo = Photo.find_by_id(params[:id])
  end

  def gchat
    @chats = paginate_arr(session_shop.gchat, params[:page], 15).to_a
  end



  #用户照片隐藏
  def ajax_del
    photo = Photo.find(params[:id])
    photo.set(:hide, true)
    expire_cache_shop(photo.room)
    render :json => {}
  end

  #商家照片删除
  def ajax_shop_photo_del
    @shop_photo = Photo.find_by_id(params[:id])
    text = (@shop_photo.destroy ? '删除成功.' : nil)
    render :json => {text: text}
  end

  def ajax_undel
    photo = Photo.find(params[:id])
    photo.unset(:hide)
    expire_cache_shop(photo.room)
    render :json => {}
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

  def hide_com
    photo = Photo.find(params[:id])
    result = photo.hidecom(params[:uid], params[:txt])
    return render :json => {:text => result } if result
    Rails.cache.delete("Photo#{photo.id.to_s}")
    expire_cache_shop(photo.room)
    render nothing: true
  end

  def unhide_com
    photo = Photo.find(params[:id])
    result = photo.unhidecom(params[:uid], params[:txt])
    return render :json => {:text => result } if result
    Rails.cache.delete("Photo#{photo.id.to_s}")
    expire_cache_shop(photo.room)
    render nothing: true
  end
  private
  def expire_cache_shop(sid)
    Rails.cache.delete("SP#{sid}-5")
    Rails.cache.delete("views/SI#{sid}.json")
  end


end