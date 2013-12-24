class OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def execute
    order = Order.find(params[:id])
    payer_id = params[:PayerID]
    item = order.enrollable

    if order.execute(payer_id)
      current_user.enroll(item)
      redirect_to item, flash: { success: "Enrolled Successful"}
    else
      redirect_to item, flash: {error: "Opps, something went wrong"}
    end
  end


  def show
    @order = Order.find params[:id]
  end

end
