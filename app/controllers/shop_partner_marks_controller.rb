class ShopPartnerMarksController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop'
  
  def index
    hash = {:admin_sid => session[:shop_id]}
    sort = {_id: -1}
    @shop_marks = paginate("ShopMark", params[:page], hash, sort,10)
  end



end
