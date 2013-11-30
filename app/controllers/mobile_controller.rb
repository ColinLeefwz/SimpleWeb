# coding: utf-8

class MobileController < ApplicationController

  layout "mobile"

  def index

  end

  def index2
    if params[:sid]
      @mobile_space = MobileSpace.where({sid:params[:sid]}).first
      @mobile_banners = MobileBanner.where({sid: params[:sid]}).sort({_id:-1})
      @mobile_welcome_banner = MobileBanner.find_by_id("[#{params[:sid]}]2")
      @mobile_articles = MobileArticle.where({sid: params[:sid]}).sort({_id:-1})
      @shop = Shop.find_by_id(params[:sid])
      @contact_lianlian_page = MobileArticle.find_by_id("[#{params[:sid]}]0") 
      @welcome_page = MobileArticle.find("[#{params[:sid]}]1")
    end
    render :layout => false
  end

  def map
    @shop = Shop.find_by_id(params[:sid])
    # lo = @shop.lo
    # if lo.nil?
    #   render :json => { poi: "120.128376,30.286706" }
    # elsif lo.size == 1
    #   render :json => { poi: "#{lo[0]},#{lo[1]}" }
    # else
    #   render :json => { poi: "#{lo[0][0]},#{lo[0][1]}" }
    # end
    render :layout => false
  end

  def contact
    @shopinfo = ShopInfo.find_by_id(params[:sid])
    @shop = Shop.find_by_id(params[:sid])
    render :layout => false
  end

  def company
    @shop = Shop.find_by_id(params[:sid])
    @shopinfo = ShopInfo.find_by_id(params[:sid])
    render :layout => false
  end

  def news
    @mobile_articles = MobileArticle.where({sid: params[:sid]}).sort({_id:-1})
    @shop = Shop.find_by_id(params[:sid])
    render :layout => false
  end

  def content
    @shop = Shop.find_by_id(params[:sid])
    @mobile_space = MobileSpace.where({sid:params[:sid]}).first
    @mobile_articles = MobileArticle.where({sid:params[:sid],category:params[:c]}).sort({_id:-1})
    @contact_lianlian_page = MobileArticle.find_by_id("[#{params[:sid]}]0") 
    @welcome_page = MobileArticle.find("[#{params[:sid]}]1")
    render :layout => false
  end

end