

class Shop3NoticeController < ApplicationController
  before_filter :shop_authorize
  layout 'shop3'
  
  def index
    @shop_notice = session_shop.notice
  end

end
