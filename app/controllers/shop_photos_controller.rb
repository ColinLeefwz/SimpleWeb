# coding: utf-8

class ShopPhotosController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    hash = {:room => session[:shop_id].to_i.to_s, :hide => nil}
    sort = {:updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,10)
  end

  def ajax_del
    photo = Photo.find(params[:id])
    photo.update_attribute(:hide, true)
    render :json => {:text => '删除成功'}
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
    render :json => {:text => result ? 0 : 1 }
  end

end
