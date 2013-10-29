require 'paypal'
require 'mandrill_api'

class SessionsController < ApplicationController
  before_action :set_session

  def post_a_draft
    @session.draft = false

    if @session.save
      redirect_to dashboard_expert_path(current_user), notice: 'draft post'
    else
      redirect_to dashboard_expert_path(current_user), notice: 'failed'
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
    if @session.is_a?ArticleSession
      render 'text_page'
    else
      render 'video_page'
    end
  end

  def edit_live_session
    @live_session = LiveSession.find(params[:id])
    authorize! :edit_live_session, @live_session
    @from = "experts/live_session"
    @url = "update_live_session_session_path"
    respond_to do |format| 
      format.js {render 'experts/update'}
    end
  end

  def update_live_session
    @session.update  
    @from = "sessions"
    respond_to do |format| 
      format.js {render 'experts/update'}
    end
  end

  private

  def set_session
    @session = Session.find params[:id]
  end

  def member_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :time_zone)
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

