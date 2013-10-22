class ExpertsController < ApplicationController
  load_and_authorize_resource

  def dashboard
    @sessions = @expert.sessions
  end

  def new_post_content
    @article_session = ArticleSession.new
  end

  def create_post_content
    @article_session = ArticleSession.new(article_params)
    @article_session.expert = current_user

    if @article_session.save
      redirect_to dashboard_expert_path(current_user), notice: 'successful'
    else
      redirect_to dashboard_expert_path(current_user), notice: 'failed'
    end
  end
  
  def new_session
    @live_session = Session.new
  end
  
  private
    def article_params
      params.require(:article_session).permit(:title, :description, :cover, {categories:[]} )
    end

    def expert_params
      params.require(:expert).permit(:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
    end

end
