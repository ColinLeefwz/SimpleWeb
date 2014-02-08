class ArticlesController < ApplicationController
  before_action :set_article, except: [:new_post_content, :create_post_content]

  def post_a_draft
    @article.draft = false
    @article.save

    @articles = current_user.articles
    @from = "articles"
    respond_to do |format| 
      format.js {render 'experts/update'}
    end
  end

  def show
  end

  def update_timezone
    @zone = params[:time_zone][:time_zone]
    respond_to do |format|
      format.js {}
    end
  end


  def new_post_content
    @article = Article.new  # use Article.new so that form params are wrapped in :article
    @article.expert = current_user
    @url = create_post_content_articles_path
    @from = 'post_content'
    respond_to do |format|
      format.js { render 'experts/update'}
    end
  end

  def create_post_content
    @article = Article.new(article_article_params)
    create_response
  end

  def edit_content
    @from = "post_content"
    @url = update_content_article_path(@article)
    respond_to do |format|
      format.js {render 'experts/update'}
    end
  end

  def cancel_content
    @article.update_attributes canceled: true
    @from = 'articles'
    @articles = current_user.articles.where("canceled = false")

    respond_to do |format|
      format.js { render 'experts/update' }
    end
  end

  def cancel_draft_content
    @article.update_attributes canceled: true
    @items = current_user.contents
    @show_shares = true
    @from = 'articles/articles'
    respond_to do |format|
      format.js { render 'experts/update'}
    end
  end

  def update_content
    @article.update_attributes(article_article_params)

    update_article_draft

    @items = current_user.contents
    @from = "articles"
    render 'experts/update'
  end

  def email_friend
    @email = params[:email_friend]
    mandrill = MandrillApi.new
    mandrill.email_friend_article(@email, article_url(@article))
    redirect_to article_path(@article), flash: {success: "mail send successfully!"}
  end

  private
  def create_response
    @article.expert = current_user
    @items = current_user.articles.order("draft desc")
    respond_to do |format|
      format.js{
        update_article_draft
        @from = "articles"
        render 'experts/update'
      }
    end
  end

  def update_article_draft
    case params[:commit]
    when Article::COMMIT_TYPE[:publish]
      @article.update_attributes draft: false
    when Article::COMMIT_TYPE[:draft]
      @article.update_attributes draft: true
    end
  end

  def set_article
    @article = Article.find params[:id]
  end

  def member_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :time_zone)
  end

  def article_params
    params.require(:article).permit(:title, {categories:[]}, :cover, :description, :language)
  end

end

