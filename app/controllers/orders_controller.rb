class OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def execute
    order = Order.find(params[:order_id])
    payment = Payment.find(order.payment_id)
    item = order.enrollable
    if payment.execute(payer_id: params[:PayerID])
      current_user.enroll(item)
      redirect_to send("#{item.class.name.downcase}_path", item.id), flash: { success: "Enrolled Successful"}
    else
      redirect_to send("#{item.class.name.downcase}_path", item.id), flash: {error: "Opps, something went wrong"}
    end
  end


  def show
    @order = Order.find params[:id]
  end

end
