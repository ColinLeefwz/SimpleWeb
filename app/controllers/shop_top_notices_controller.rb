# encoding: utf-8
class ShopTopNoticesController < ApplicationController
  before_filter :shop_authorize
  layout 'shop'
  #  before_filter :operate_auth, :only => [:show, :edit,:destroy]
  # GET /shop_notices
  # GET /shop_notices.json

  def index
    @shop_notice = ShopTopNotice.where({shop_id: session_shop.id}).last
  end

  def ajax_release
    @shop_notice = ShopTopNotice.find_or_new(params[:id])
    @shop_notice.title = params[:title]
    @shop_notice.shop_id = session_shop.id
    @shop_notice.save
    render :json => {:title => @shop_notice.title, :id => @shop_notice.id }
  end

  def delete
    @shop_notice = ShopTopNotice.find(params[:id])
    @shop_notice.delete
    redirect_to :action => "index"
  end

end