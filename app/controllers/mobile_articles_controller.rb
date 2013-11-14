class MobileArticlesController < ApplicationController
  before_filter :shop_authorize, :except => [:mobile_show]
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
    @mobile_article = MobileArticle.find_by_id(params[:id])
    render :layout => false
  end

  def mobile_show
    @mobile_articles = session_shop.mobile_articles
    render :layout => false
  end

end
