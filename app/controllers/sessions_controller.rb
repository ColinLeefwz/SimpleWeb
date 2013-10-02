class SessionsController < ApplicationController

	before_action :set_session, only: [:show, :edit, :update, :destroy]


	def enroll
		@session = Session.find params[:id]
	end

	def free_confirm
		@session = Session.find params[:id]
		current_user.enroll_session @session
		redirect_to session_path(@session), flash: { success: "Enrolled Successful !" }
	end

	def sign_up_confirm
		@session = Session.find params[:id]
		@member = Member.new(member_params)
		if @member.save
			sign_in @member
			current_user.enroll_session @session
			redirect_to session_path(@session), flash: { success: "Enrolled Successful !" }
		else
			redirect_to session_path(@session), alert: "Can not sign up you !"
		end
	end

	def buy_now
		@session = Session.find params[:id]
		paypal_pay
	end

	def sign_up_buy
		@session = Session.find params[:id]
		@member = Member.new(member_params)
		if @member.save
			sign_in @member
			paypal_pay
		else
			redirect_to session_path(@session), alert: "Can not sign up you !"
		end

	end

  def show
    # @session = Session.find(params[:id])
    if @session.is_a?ArticleSession
      render 'text_page'
    else
      render 'video_page'
    end
  end

	private
  def set_session
    @session = Session.find(params[:id])
  end

	def member_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
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

end

