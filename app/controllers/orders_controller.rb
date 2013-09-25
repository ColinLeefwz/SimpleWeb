class OrdersController < ApplicationController
	def index
		@orders = current_user.orders.all
	end

	def create
		@order = current_user.orders.build
		@order.attributes = params[:order]
		@order.return_url = order_execute_url(":order_id")
		@order.cancel_url = order_cancel_url(":order_id")

		if @order.payment_method and @order.save
			if @order.approve_url
				redirect_to @order.approve_url
			else
				redirect_to orders_path, notice: "Session enrolled successfully"
			end
		else
			render :create, alert: @order.errors.to_a.join(", ")
		end
	end

	def execute
		order = Order.find(params[:order_id])
		@payment = Payment.find(order.payment_id)
		@session = order.session.id
		if @payment.execute(payer_id: params[:PayerID])
			logger.info "finish enroll"
			redirect_to video_page_path @session
			# redirect_to session_path(@session)
		else
			logger.info "enrolled failed"
			redirect_to session_path(@session)
		end
	end

	def show
		@order = Order.find params[:id]
	end

end
