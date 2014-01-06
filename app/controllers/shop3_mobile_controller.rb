# coding: utf-8

class Shop3MobileController < ApplicationController

  before_filter :shop_authorize, :except => [:show]
  layout 'shop3'
  
  def index
  	@mobile_space = MobileSpace.where({sid: session_shop.id}).first
    if @mobile_space
      redirect_to "/shop3_mobile/index2"
    else
      render :action => "new"   	
    end
  end

  def index2

  end

  def index3
    @mobile_space = MobileSpace.where({sid: session_shop.id}).first
    if @mobile_space
      redirect_to "/shop3_mobile/index4"
    else
      redirect_to "/shop3_mobile/index5"    
    end
  end

end