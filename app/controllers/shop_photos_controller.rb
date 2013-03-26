# coding: utf-8

class ShopPhotosController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'

  def index
    hash = {:room => session[:shop_id].to_s}
    sort = {:updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,10)
  end

  def ajax_del
    photo = Photo.find(params[:id])
    photo.delete
    render :json => {:text => '删除成功'}
  end

end
