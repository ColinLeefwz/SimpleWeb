class Shop3CaseController < ApplicationController
  before_filter :shop_authorize
  layout "shop3"


  def index

  end

  def new
    @case = ShopCase.new
  end

end