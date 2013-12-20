class SessionsController < ApplicationController
  before_action :set_session, except: [:new_live_session, :new_post_content, :create_post_content, :create_live_session]

  def post_a_draft
    @session.draft = false
    @session.save

    @sessions = current_user.sessions
    @from = "sessions"
    respond_to do |format| 
      format.js {render 'experts/update'}
    end
  end

  def enroll
    #todo: move this template into shared folder
    render "courses/enroll", locals: {item: @session}
  end

  def enroll_confirm
    current_user.enroll(@session)
    send_enrolled_mail(@session)

    redirect_to @session, flash: {success: "Enrolled Success!"}
  end

  def purchase
    paypal_pay(@session)
  end

  # todo: use Exception and Catch mechanism to deal with all accidents(maybe in the application_controller)
  def sign_up_confirm
    member = Member.create(member_params)
    sign_in member

    if @session.free?
      redirect_to enroll_confirm_session_path(@session)
    else
      redirect_to purchase_session_path(@session)
    end

  end

  def show
    if @session.is_a? ArticleSession
      render 'content'
    # elsif @session.is_a? VideoSession
    elsif @session.is_a? VideoInterview
      render 'video'
    elsif @session.is_a? Announcement
      render 'announcement'
    end
  end

  def update_timezone
    @zone = params[:time_zone][:time_zone]
    respond_to do |format|
      format.js {}
    end
  end


  def new_live_session
    @session = LiveSession.new
    @session.expert = current_user
    @from = 'live_session'
    @url = create_live_session_sessions_path
    respond_to do |format|
      format.js { render 'experts/update'}
    end
  end

  def create_live_session
    @session = LiveSession.new(live_session_params)
    create_response
  end

  def edit_live_session
    authorize! :edit_live_session, @session
    @from = "live_session"
    @url = update_live_session_session_path(@session)
    respond_to do |format| 
      format.js {render 'experts/update'}
    end
  end

  def update_live_session
    @session.assign_attributes(live_session_params)
    create_response
  end

  def new_post_content
    @session = ArticleSession.new  # use Session.new so that form params are wrapped in :session
    @session.expert = current_user
    @url = create_post_content_sessions_path
    @from = 'post_content'
    respond_to do |format|
      format.js { render 'experts/update'}
    end
  end

  def create_post_content
    @session = ArticleSession.new(article_session_params)
    create_response
  end

	# TODO: can we refactor this one with the "edit_live_session" ?
  def edit_content
    authorize! :edit_content, @session
    @from = "post_content"
    @url = update_content_session_path(@session)
    respond_to do |format|
      format.js {render 'experts/update'}
    end
  end

	def cancel_content
    authorize! :edit_content, @session
		@session.update_attributes canceled: true
		@from = 'sessions'
		@sessions = current_user.sessions.where("canceled = false")

		respond_to do |format|
			format.js { render 'experts/update' }
		end
	end

  def update_content
    @session.assign_attributes(article_session_params)
    create_response
  end

	def email_friend
		@email = params[:email_friend]
		mandrill = MandrillApi.new
		mandrill.email_friend_session(@email, session_url(@session))
		redirect_to session_path(@session), flash: {success: "mail send successfully!"}
	end

  private
  def create_response
    @session.expert = current_user
    @sessions = current_user.sessions.order("draft desc")
    respond_to do |format|
      format.js{
        if params[:commit] == Session::COMMIT_TYPE[:publish]
          @session.draft = false
          @session.save
          @from = "sessions"
          render 'experts/update'
        elsif params[:commit] == Session::COMMIT_TYPE[:draft]
          @session.draft = true
          @session.save
          @from = "sessions"
          render 'experts/update'
        end
      }
    end
  end

  def set_session
    @session = Session.find params[:id]
  end

  def member_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :time_zone)
  end

  def live_session_params
    params.require(:live_session).permit(:title, {categories:[]}, :format, :cover, :video, :date, :start_time, :end_time, :time_zone, :location, :price, :strategic_question, :description, :language)
  end

  def article_session_params
    params.require(:article_session).permit(:title, {categories:[]}, :cover, :description, :language)
  end

end

