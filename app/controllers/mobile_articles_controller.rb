class MobileArticlesController < ApplicationController
  before_filter :shop_authorize, :except => [:show, :mobile_show]
  include Paginate
  layout "mobile"

  def index
    @mobile_articles = session_shop.mobile_articles
  end

  def new
    @mobile_article = MobileArticle.new
  end

  def create
    @mobile_article = MobileArticle.new(params[:mobile_article])
    @mobile_article.sid = session[:shop_id]

    if @mobile_article.save
      redirect_to "/mobile_articles/index"
    else
      render :action => "new"
    end
  end

  def show
    if params[:sid]
      @shop = Shop.find_by_id(params[:sid])
      @mobile_article = MobileArticle.where({id:params[:id],sid:params[:sid]}).first
      if @mobile_article
        @mobile_article
      else
        nil
      end
    else
      nil
    end
    render :layout => false
  end

  def mobile_show
    @mobile_articles = session_shop.mobile_articles
    render :layout => false
  end

end
