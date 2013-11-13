require 'paypal'
require 'mandrill_api'

class SessionsController < ApplicationController
  before_action :set_session, except: [:new_live_session, :new_post_content, :create_post_content, :create_live_session, :sessions]

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
    if user_signed_in?
      if current_user.enrolled_sessions.include? @session
        @include = true
      else
        @include = false
      end

      if @session.is_free?
        @free_session = true
      else
        @free_session = false
      end
    end
  end

  def free_confirm
    enroll_redirect
  end

  def sign_up_confirm
    @member = Member.new(member_params)
    if @member.save
      sign_in @member

      enroll_redirect
    else
      redirect_to session_path(@session), alert: "Can not sign up you !"
    end
  end

  def buy_now
    paypal_pay
  end

  def sign_up_buy
    @member = Member.new(member_params)
    if @member.save
      sign_in @member
      paypal_pay
    else
      redirect_to session_path(@session), alert: "Can not sign up you !"
    end

  end

  def show
    if @session.is_a? ArticleSession
      render 'text_page'
    else
      render 'video_page'
    end
  end

  def update_timezone
    @zone = params[:time_zone][:time_zone]
    respond_to do |format|
      format.js {}
    end
  end

  def sessions
    @sessions = current_user.sessions.order("draft desc")
    @from = 'sessions'
    respond_to do |format|
      format.js { render 'experts/update'}
    end
  end

  def new_live_session
    @session = LiveSession.new
    @session.expert = current_user
    @from = 'live_session'
    @url = create_live_session_expert_sessions_path(current_user)
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
    @url = create_post_content_expert_sessions_path(current_user)
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
    @session.assign_attibutes(article_session_params)
    create_response
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
    params.require(:live_session).permit(:title, {categories:[]}, :format, :cover, :video, :date, :start_time, :end_time, :time_zone, :location, :price, :strategic_question, :description)
  end

  def article_session_params
    params.require(:article_session).permit(:title, {categories:[]}, :cover, :description)
  end

  def paypal_pay
    @order = @session.orders.build
    @order.user = current_user

    if @order.save
      Paypal.create_payment_with_paypal(@session, @order, order_execute_url(@order.id))

      if @order.approve_url
        redirect_to @order.approve_url
      else
        redirect_to session_path(@session)
      end
    else
      render :create, alert: @order.errors.to_a.join(", ")
    end
  end

  def enroll_redirect
    current_user.enroll_session @session
    send_mail
    redirect_to session_path(@session), flash: { success: "Enrolled Successful !" }
  end

  def send_mail
    domain_url = request.base_url
    if domain_url == "http://localhost:3000"
      domain_url = "http://www.prodygia.com"
    end

    session_image_url = domain_url + @session.cover.url
    mandrill = MandrillApi.new
    mandrill.enroll_comfirm(current_user, @session, session_image_url)
  end
end

