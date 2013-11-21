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
    @mobile_banners = session_shop.mobile_banners
    render :layout => false
  end

  def edit
    @mobile_article = MobileArticle.find_by_id(params[:id])
  end

  def update
    @mobile_article = MobileArticle.find_by_id(params[:id])
    if @mobile_article.update_attributes(params[:mobile_article])
      redirect_to :action => "index"
    else
      render :action => :edit
    end
  end

  def ajax_del
    @mobile_article = MobileArticle.find_by_id(params[:id])
    if @mobile_article.destroy
      redirect_to "/mobile_articles/index"
    else
      redirect_to "/mobile_articles/index"
    end
  end

  def article_image_upload
    image = Image.new
    image.article_id = params[:id]
    image.img = params[:upfile]
    image.save!
    render :json=>{:url => image.img.url, 'state'=>'SUCCESS', :title=>params[:pictitle]}  
  end

end
