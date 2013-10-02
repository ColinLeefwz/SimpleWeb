class OrdersController < ApplicationController
	def index
		@orders = current_user.orders.all
	end

	def execute
		order = Order.find(params[:order_id])
		@payment = Payment.find(order.payment_id)
		@session = order.session
		if @payment.execute(payer_id: params[:PayerID])
			current_user.enroll_session @session
			redirect_to session_path(@session), flash: { success: "Enrolled Successful !" }
		else
			redirect_to session_path(@session)
		end
	end

	def show
		@order = Order.find params[:id]
	end

end
