# coding: utf-8

class MobileController < ApplicationController

  layout "mobile"

  def index

  end

  def index2
    if params[:sid]
      @mobile_articles = MobileArticle.where({sid: params[:sid]}).sort({_id:-1})
      @shop = Shop.find_by_id(params[:sid])
      @mobile_banners = MobileBanner.where({sid: params[:sid]}).sort({_id:-1})
    end
    render :layout => false
  end

end