# coding: utf-8

class Shop3ContentController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop3'

  def user_photo
    hash = {:room => session[:shop_id].to_i.to_s, :user_id => {"$ne" => "s#{session[:shop_id]}" }}
    hash.merge!({user_id: params[:uid]}) unless params[:uid].blank?
    sort = {:od => -1, :updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,20)
  end

  def shop_photo
    hash = {:room => session[:shop_id].to_i.to_s, :user_id => "s#{session[:shop_id]}" }
    sort = {:od => -1, :updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,20)
  end

  def show_photo
    @photo = Photo.find_by_id(params[:id])
  end

  def new_photo
    @photo = Photo.new
  end

  def delete_photo
    photo = Photo.find(params[:id])
    Rails.cache.delete("Photo#{photo.id}")

    #照片设置为公告时， 删除公告
    if session_shop.notice && session_shop.notice.photo_id.to_s == photo.id.to_s
      session_shop.notice.delete
    end
    Gchat.delete_all(mid: photo.mid)
    photo.delete
    expire_cache_shop(photo.room)
    respond_to do |format|
      format.html {redirect_to :action => "shop_photo"}
      format.json { render :json => {} }
    end
    
  end

  def create_photo
    @shop_photo = Photo.new(params[:photo])
    @shop_photo.room = session[:shop_id].to_i.to_s
    @shop_photo.user_id = "s#{session[:shop_id]}"

    if @shop_photo.save
      flash[:success] = "上传到图片墙成功！"
      expire_cache_shop(session[:shop_id])
      redirect_to :action => "shop_photo"
    else
      flash.now[:error] = '上传到图片墙失败！'
      render :action => "new_photo"
    end
  end

  def edit_photo
    @photo = Photo.find(params[:id])
  end


  def update_photo
    @shop_photo = Photo.find_by_id(params[:id])
    if @shop_photo.update_attributes(params[:photo])
      expire_cache_shop(@shop_photo.room)
      redirect_to :action => "shop_photo"
    else
      render :action => "edit_photo"
    end
  end


  def gchat
    hash = {sid: session[:shop_id].to_i}
    sort = { _id: -1}
    @chats = paginate("gchat", params[:page], hash, sort)
  end

  def ajax_pb
    gchat = Gchat.find_by_id(params[:id])
    gchat.set(:del, true)
    render :json => {}
  end

  def ajax_unpb
    gchat = Gchat.find_by_id(params[:id])
    gchat.unset(:del)
    render :json => {}
  end


  #用户照片隐藏
  def ajax_del
    photo = Photo.find(params[:id])
    photo.set(:hide, true)
    Gchat.delete_all(mid: photo.mid)
    expire_cache_shop(photo.room)
    render :json => {}
  end

  #商家照片删除
  def ajax_shop_photo_del
    @shop_photo = Photo.find_by_id(params[:id])
    text = (@shop_photo.destroy ? '删除成功.' : nil)
    expire_cache_shop(photo.room)
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
    expire_cache_shop(photo.room)
    render :json => {}
  end

  def ajax_untop
    photo = Photo.find(params[:id])
    photo.unset(:od)
    expire_cache_shop(photo.room)
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
    PhotoCache.new.del_shop_photo_cache(sid,0,5)
    PhotoCache.new.del_user_photo_cache("s"+sid,0,5)
  end


end