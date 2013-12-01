class MobileArticlesController < ApplicationController
  before_filter :shop_authorize, :except => [:show, :mobile_show]
  include Paginate
  layout "mobile"

  def index
    @shop = session_shop
    @mobile_articles = MobileArticle.where({sid:session_shop.id, category:params[:c]})
    @contact_lianlian_page = MobileArticle.find_by_id("[#{session_shop.id}]0")
    @welcome_page = MobileArticle.find("[#{session_shop.id}]1")
  end

  def new
    @mobile_article = MobileArticle.new
  end

  def create
    @mobile_article = MobileArticle.new(params[:mobile_article])
    @mobile_article.sid = session[:shop_id]
    @mobile_article.category = params[:c]

    if @mobile_article.save
      redirect_to URI::escape("/mobile_articles/index?c=#{params[:c]}")
    else
      render :action => URI::escape("new?c=#{params[:c]}")
    end
  end

  def show
    if params[:sid]
      @shop_info = ShopInfo.find_by_id(params[:sid])
      @shop = Shop.find_by_id(params[:sid])
      @mobile_space = MobileSpace.where({sid:params[:sid]}).first
      @mobile_article = MobileArticle.where({id:params[:id],sid:params[:sid]}).first
      @init_mobile_article = MobileArticle.where({id:params[:id]}).first
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
    @mobile_space = MobileSpace.where({sid:session_shop.id}).first
    @mobile_articles = session_shop.mobile_articles
    @mobile_welcome_banner = MobileBanner.find_by_id("[#{session_shop.id}]2")
    @mobile_banners = session_shop.mobile_banners
    @contact_lianlian_page = MobileArticle.find_by_id("[#{session_shop.id}]0") 
    @welcome_page = MobileArticle.find("[#{session_shop.id}]1")
    @shop = session_shop
    @sid = session_shop.id 
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
    @mobile_article = MobileArticle.where({id: params[:id]}).first
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

  def news
    @mobile_articles = session_shop.mobile_articles
    @shop = session_shop
    @sid = session_shop.id 
    render :layout => false
  end

  def contact
    @shop = session_shop
    @shopinfo = session_shop.info
    @sid = session_shop.id 
    render :layout => false
  end

  def company
    @shop = session_shop
    @shopinfo = session_shop.info
    @sid = session_shop.id 
    render :layout => false
  end

  def intro
    
  end

  def content
    @mobile_space = MobileSpace.where({sid:session_shop.id}).first
    @mobile_articles = MobileArticle.where({sid:session_shop.id,category:params[:c]})
    @contact_lianlian_page = MobileArticle.find_by_id("[#{session_shop.id}]0") 
    @welcome_page = MobileArticle.find("[#{session_shop.id}]1")
    @sid = session_shop.id 
    render :layout => false
  end

end
