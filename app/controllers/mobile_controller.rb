# coding: utf-8

class MobileController < ApplicationController

  layout "mobile"

  def index

  end

  def index2
    if params[:sid]
      @mobile_articles = MobileArticle.where({sid: params[:sid]})
      @shop = Shop.find_by_id(params[:sid])
    end
    render :layout => false
  end

end