class ExpertsController < ApplicationController
  load_and_authorize_resource

  def dashboard
    @sessions = @expert.sessions.order("draft desc")
  end

  def new_post_content
    @article_session = Session.new  # use Session.new so that form params are wrapped in :session
  end

  def create_post_content
    @article_session = ArticleSession.new(session_params)
    @article_session.expert = current_user

    if @article_session.save
      redirect_to dashboard_expert_path(current_user), notice: 'successful'
    else
      redirect_to dashboard_expert_path(current_user), notice: 'failed'
    end
  end
  
  def new_live_session
    @live_session = Session.new
  end


  def create_live_session
    @live_session = LiveSession.new(session_params)
    @live_session.expert = current_user

    case params[:commit]
    when "Save Draft"
      @live_session.draft = true
      notice = "Draft Saved"
    when "Preview"
    when "Submit"
      notice = "successful"
    end

    if @live_session.save
      redirect_to dashboard_expert_path(current_user), notice: notice
    else
      redirect_to dashboard_expert_path(current_user), notice: 'failed'
    end
  end

  
  private
    def session_params
      params.require(:session).permit(:title, :description, :cover, :video, {categories:[]}, :location, :price, :language, :start_date ) 
    end

    def expert_params
      params.require(:expert).permit(:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
    end

end
