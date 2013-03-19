# encoding: utf-8
class ShopShopNoticesController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'
  #  before_filter :operate_auth, :only => [:show, :edit,:destroy]
  # GET /shop_notices
  # GET /shop_notices.json
  def index
    @shop_notice = session_shop.notice
  end

  def ajax_release
    @shop_notice = ShopNotice.find_or_new(params[:id])
    @shop_notice.title = params[:title]
    @shop_notice.shop_id = session_shop.id
    @shop_notice.save
    render :json => {:title => @shop_notice.title, :id => @shop_notice.id }
  end

  def del
    @shop_notice = ShopNotice.find_or_new(params[:id])
    @shop_notice.destroy
    redirect_to :action => "index"
  end

end