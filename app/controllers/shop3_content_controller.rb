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

  def gchat
    @chats = paginate_arr(session_shop.gchat, params[:page], 15).to_a
  end

end