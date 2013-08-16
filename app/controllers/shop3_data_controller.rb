# coding: utf-8

class Shop3DataController < ApplicationController
  before_filter :shop_authorize
  include Paginate
  layout "shop3"

  def index

  end

end