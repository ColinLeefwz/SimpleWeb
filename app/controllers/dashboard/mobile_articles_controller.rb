# class MobileArticlesController < ApplicationController
class Dashboard::MobileArticlesController < Dashboard::BaseController

  layout "mobile"

  def index
    # @articles_scope = Article.scoped
    if params[:name]
      @space = MobileSpace.where(:name => params[:name]).first
      # @articles_scope = @articles_scope.where(:space_id => (@space ? @space.id : nil))
    end
    @mobile_articles = MobileArticle.where(:mobile_space_id => (@space ? @space.id : nil)).sort({:_id => -1})

    # @articles = case params[:tab]
    #             when 'all'
    #               @articles_scope.desc(:updated_at).includes(:space).page(params[:page]).per(25)
    #             else
    #               @articles_scope.publish.desc(:published_at).includes(:space).page(params[:page]).per(25)
    #             end
  end

  # def new
  #   @mobile_article = MobileArticle.new
  # end

  # def create
  #   @mobile_article = MobileArticle.new(params[:mobile_article])
  #   if @mobile_article.save
  #     redirect_to dashboard_root_path
  #   else
  #     render :action => "new"
  #   end
  # end

  def new
    @mobile_article = @space.mobile_articles.new
    # append_title @article.title
    # render :edit, :layout => 'editor'
  end

  def create
    @mobile_article = @space.mobile_articles.new(params[:mobile_article])
    if @mobile_article.save
      redirect_to dashboard_root_path
    else
      render :action => "new"
    end
  end

  def edit
    @mobile_article = @space.mobile_articles.where(:id => params[:id]).first
  end

  def update
    @mobile_article = @space.mobile_articles.where(:id => params[:id]).first
    if @mobile_article.update_attributes(params[:mobile_article])
      redirect_to dashboard_root_path
    else
      render :action => :edit
    end
  end

  def show
    # @article = Article.find params[:id]
    if params[:name]
      @space = MobileSpace.where(:name => params[:name]).first
    end
    @mobile_articles = MobileArticle.where(:mobile_space_id => (@space ? @space.id : nil)).sort({:_id => -1})
    render :layout =>false
  end

  def mobile_show
    if params[:name]
      @space = MobileSpace.where(:name => params[:name]).first
    end
    @mobile_articles = MobileArticle.where(:mobile_space_id => (@space ? @space.id : nil))
    render :layout =>false
  end

end
