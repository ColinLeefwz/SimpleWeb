class ArticlesController < ApplicationController
  before_action :set_article, except: [:new, :create, :preview]

  def new
    @article = Article.new
    respond_to do |format|
      format.js {
        render partial: "article_form"
      }
    end
  end

  def create
    @article = current_user.articles.create(article_params)
    respond_to do |format|
      format.js {
        render partial: "shared/cards", locals: {items: current_user.contents}
      }
    end
  end

  def edit
    respond_to do |format|
      format.js {
        render partial: "article_form"
      }
    end
  end

  def update
    @article.update_attributes(article_params)
    respond_to do |format|
      format.js{
        render partial: "shared/cards", locals: {items: current_user.contents}
      }
    end
  end

  def post_a_draft
    @article.update_attributes(draft: false)
    respond_to do |format|
      format.js {
        render partial: "shared/cards", locals: {items: current_user.contents}
      }
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

  def cancel_draft_content
    @article.update_attributes canceled: true
    @items = current_user.contents
    respond_to do |format|
      format.js {
        @show_shares = true
        render partial: 'shared/cards', locals: { items: @items }
      }
    end
  end

  def email_friend
    @email = params[:email_friend]
    mandrill = MandrillApi.new
    mandrill.email_friend_article(@email, article_url(@article))
    redirect_to article_path(@article), flash: {success: "mail send successfully!"}
  end

  private
  def set_article
    @article = Article.find params[:id]
  end

  def article_params
    params.require(:article).permit(:title, {categories:[]}, :cover, :description, :language, :draft)
  end

end

