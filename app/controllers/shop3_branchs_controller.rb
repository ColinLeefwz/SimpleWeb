# encoding: utf-8

class Shop3BranchsController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout 'shop3'
  
  def index
    hash = {psid: session[:shop_id]}
    sort = {_id: -1}
    @shops = paginate("Shop", params[:page], hash, sort,10)
  end

end
