require 'paypal-sdk-rest'
include PayPal::SDK::REST
include PayPal::SDK::Core::Logging

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
			@order.approve_url = create_payment_with_paypal(@session)

			if @order.approve_url
				redirect_to @redirect_url
			else
				logger.info "enrolled successfully"
				redirect_to session_path(@session)
			end
		else
			render :create, alert: @order.errors.to_a.join(", ")
		end

	end

	def create_payment_with_paypal(paid_session)
		# price = paid_session.price.to_s
		@payment = Payment.new({
			:intent =>  "sale",

			# ###Payer
			# A resource representing a Payer that funds a payment
			# Payment Method as 'paypal'
			:payer =>  {
				:payment_method =>  "paypal" },

			# ###Redirect URLs
			:redirect_urls => {
				:return_url => order_execute_url(@order.id),
				:cancel_url => "http://localhost:3000/" },

			# ###Transaction
			# A transaction defines the contract of a
			# payment - what is the payment for and who
			# is fulfilling it.
			:transactions =>  [{

				# Item List
				:item_list => {
					:items => [{
						:name => paid_session.title,
						# :sku => "item",
						:price => '%.2f' % paid_session.price,
						:currency => "USD",
						:quantity => 1 }]},

				# ###Amount
				# Let's you specify a payment amount.
				:amount =>  {
					:total =>  '%.2f' % paid_session.price,
					:currency =>  "USD" },
					:description =>  "This is the payment transaction description." }]})


		if @payment.create
			@order.update_attributes payment_id: @payment.id

			@redirect_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
		else
			logger.info "line 88, create failed"
		end
	end
end

