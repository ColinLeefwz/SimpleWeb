# coding: utf-8

class Shop3MobileController < ApplicationController

  before_filter :shop_authorize, :except => [:show]
  layout 'shop3'
  
  def index

  end

  def new
    redirect_to "/mobile/index"
  end

end