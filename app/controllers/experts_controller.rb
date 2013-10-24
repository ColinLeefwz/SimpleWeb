class ExpertsController < ApplicationController
  load_and_authorize_resource

  def sessions
    @sessions = @expert.sessions.order("draft desc")
    @from = 'sessions'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def dashboard
    @sessions = @expert.sessions.order("draft desc")
  end

  def new_post_content
    @article_session = Session.new  # use Session.new so that form params are wrapped in :session
    @from = 'new_post_content'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def create_post_content
    @article_session = ArticleSession.new(session_params)
    @article_session.expert = current_user
    case params[:commit]
    when "Save draft"
      @article_session.draft = true
      save_session(@article_session)
    when "Preview"
      @article_session.draft = true
      if @article_session.save
        redirect_to session_path(@article_session)
      end
    when "Createe post content"
      save_session(@article_session)
    end

  end

  def new_live_session
    @live_session = Session.new
    @from = 'new_live_session'
    respond_to do |format|
      format.js { render 'update'}
    end
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

  def pending_page
    @from = 'pending_page'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def refer_new_expert
    @expert = current_user
		@email_message = current_user.build_refer_message

    @from = "refer_new_expert"
    respond_to do |format|
      format.js { render "update" }
    end
  end

  private
  def set_expert
    @expert = Expert.find(params[:id])
  end

  def session_params
    params.require(:session).permit(:title, :description, :cover, :video, {categories:[]}, :location, :price, :language, :start_date )
  end

  def expert_params
    params.require(:expert).permit(:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
  end

  def save_session(session)
    if session.save
      redirect_to dashboard_expert_path(current_user), notice: 'successful'
    else
      redirect_to dashboard_expert_path(current_user), notice: 'failed'
    end
  end
end
