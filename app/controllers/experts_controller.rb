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
    @session = Session.new  # use Session.new so that form params are wrapped in :session
    @url = create_post_content_expert_path(current_user)
    @from = 'post_content'
    respond_to do |format|
      format.js { render 'update'}
    end
  end

  def create_post_content
    @session = ArticleSession.new(session_params)
    @session.expert = current_user

    @sessions = current_user.sessions.order("draft desc")

    respond_to do |format|
      format.js{

        if params[:commit] == Session::COMMIT_TYPE[:submit]
          @session.save
          @from = "sessions"
          render 'update'
          # redirect_to dashboard_expert_path(current_user)
        elsif params[:commit] == Session::COMMIT_TYPE[:draft]
          @session.draft = true
          @session.save
          @from = "sessions"
          render 'update'
          # redirect_to dashboard_expert_path(current_user)
        elsif params[:commit] == Session::COMMIT_TYPE[:preview]
          @session.draft = true
          @session.save
          # redirect_to session_path(@article_session)
          render js: "window.location='#{session_path(@session)}'"
        end
      }
    end

  end

  def new_live_session
    @session = Session.new
    @from = 'live_session'
    @url = create_live_session_expert_path(current_user)
    respond_to do |format|
      format.js { render 'update'}
    end
  end


  def create_live_session
    @session = LiveSession.new(session_params)
    @session.expert = current_user

    @sessions = current_user.sessions.order("draft desc")

    respond_to do |format|
      format.js{

        if params[:commit] == Session::COMMIT_TYPE[:submit]
          @session.save
          @from = "sessions"
          render 'update'
          # redirect_to dashboard_expert_path(current_user)
        elsif params[:commit] == Session::COMMIT_TYPE[:draft]
          @session.draft = true
          @session.save
          @from = "sessions"
          render 'update'
          # redirect_to dashboard_expert_path(current_user)
        elsif params[:commit] == Session::COMMIT_TYPE[:preview]
          @session.draft = true
          @session.save
          # redirect_to session_path(@article_session)
          render js: "window.location='#{session_path(@session)}'"
        end
      }
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
    params.require(:session).permit(:title, :description, :cover, :video, {categories:[]}, :location, :price, :language, :start_date, :time_zone )
  end

  def expert_params
    params.require(:expert).permit(:name, :avatar, :title, :company, :location, :expertise, :favorite_quote, :career, :education, :web_site, :article_reports, :speeches, :additional, :testimonials)
  end

end
