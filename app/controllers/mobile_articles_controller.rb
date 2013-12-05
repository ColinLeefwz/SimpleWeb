class MobileArticlesController < ApplicationController
  before_filter :shop_authorize, :except => [:show, :mobile_show]
  include Paginate
  layout "mobile"

  def index
    @shop = session_shop
    @mobile_articles = MobileArticle.where({sid:session_shop.id, category:params[:c]})
    @contact_lianlian_page = MobileArticle.where({id:"[#{session_shop.id}]0"}).first
    @welcome_page = MobileArticle.where({id:"[#{session_shop.id}]1"}).first
  end

  def new
    @mobile_article = MobileArticle.new
  end

  def create
    @mobile_article = MobileArticle.new(params[:mobile_article])
    @mobile_article.sid = session[:shop_id]
    @mobile_article.category = params[:c]
    @mobile_article.img2_filename = "0.jpg"

    # pre = params[:mobile_article][:img2]
    # path =  FileUtils.mkdir_p('public/mobile_article/' + @mobile_article.id.to_s).first
    # FileUtils.mv("public#{pre}", path+"/0.jpg")
    # @mobile_article.img2_filename = "0.jpg"

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
    @page1 = MobileArticle.where({id:"[#{session_shop.id}]0"}).first 
    @page2 = MobileArticle.where({id:"[#{session_shop.id}]1"}).first
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
      # unless  (pre = params[:mobile_article][:img2]).blank?
      #   path = 'public/mobile_article/' + @mobile_article.id.to_s
      #   FileUtils.rm(path+"/0.jpg")
      #   FileUtils.mv("public#{pre}", path+"/0.jpg")
      # end
    if @mobile_article.update_attributes(params[:mobile_article])
      redirect_to URI::escape("/mobile_articles/index?c=#{params[:c]}")
    else
      render :action => :edit
    end
  end

  def ajax_del
    @mobile_article = MobileArticle.where({id: params[:id]}).first
    if @mobile_article.destroy
      redirect_to URI::escape("/mobile_articles/index?c=#{params[:c]}")
    else
      redirect_to URI::escape("/mobile_articles/index?c=#{params[:c]}")
    end
  end

  def article_image_upload
    image = Image.new
    image.article_id = params[:id]
    image.img = params[:upfile]
    image.save!
    render :json=>{:url => image.img.url, 'state'=>'SUCCESS', :title=>params[:pictitle]}  
  end

  def content
    @mobile_space = MobileSpace.where({sid:session_shop.id}).first
    @mobile_articles = MobileArticle.where({sid:session_shop.id,category:params[:c]})
    @page1 = MobileArticle.where({id:"[#{session_shop.id}]0"}).first 
    @page2 = MobileArticle.where({id:"[#{session_shop.id}]1"}).first
    @contact_lianlian_page = MobileArticle.find_by_id("[#{session_shop.id}]0") 
    @welcome_page = MobileArticle.find("[#{session_shop.id}]1")
    @sid = session_shop.id 
    render :layout => false
  end

end
