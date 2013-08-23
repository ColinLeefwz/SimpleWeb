

class Shop3NoticeController < ApplicationController
  before_filter :shop_authorize
  layout 'shop3'
  
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
end
