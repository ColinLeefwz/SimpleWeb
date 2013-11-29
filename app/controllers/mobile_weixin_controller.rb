class MobileWeixinController < ApplicationController
  before_filter :shop_authorize
  layout "mobile"

  def index
    @token = Digest::SHA256.hexdigest(session_shop.id.to_s + "12191008").slice(7,8)
    redirect_to "/mobile_weixin/check" if ENV["RAILS_ENV"] == "production"
  end

  def check
    @token = Digest::SHA256.hexdigest(session_shop.id.to_s + "12191008").slice(7,8)
  end

  def new
  	@mobile_space = MobileSpace.where({sid: session_shop.id}).first
    @mobile_articles = MobileArticle.where({sid: session_shop.id, category: params[:cate]})
    @mobile_article = MobileArticle.where({sid:nil}).first

  end

  def ajax_add
    
  end

  def list
    @mobile_articles = MobileArticle.where({:sid => session_shop.id, :kw.ne => nil})
  end

  def create
    @mobile_article = MobileArticle.find_by_id(params[:aid])
    @mobile_article.kw = params[:keywords]

    if @mobile_article.save
      redirect_to "/mobile_weixin/list"
    else
      render :action => "new"
    end
  end

end