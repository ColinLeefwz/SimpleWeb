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

  def new
  	@mobile_space = MobileSpace.new
  	@mobile_space.sid = session_shop.id
  	@mobile_space.name = session_shop.name
  	@mobile_space.flag = true
  	@mobile_space.menu = ["公司介绍","产品介绍","最新动态"]
    if @mobile_space.save
      MobileArticle.create_stub(session_shop.id, 0)
      MobileArticle.create_stub(session_shop.id, 1)
      MobileBanner.create_stub(session_shop.id, 2)
      redirect_to "/mobile/index"
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