require 'paypal-sdk-rest'
include PayPal::SDK::REST
include PayPal::SDK::Core::Logging

class SessionsController < ApplicationController

  before_action :set_session, only: [:show, :edit, :update, :destroy]

  def enroll
    @session = Session.find params[:id]
  end

  def buy_now
    @session = Session.find params[:id]
    @order = @session.orders.build

    if @order.save
      @order.approve_url = create_with_paypal(@session)

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

  private
  def create_with_paypal(paid_session)
    logger.info "create with paypal"
    price = paid_session.price.to_s
    logger.info "the price is #{price}"
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
                :sku => "item",
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
      logger.info "Payment[#{@payment.id}]"
      logger.info "Redirect: #{@redirect_url}"
      logger.info "approve_url will be #{@redirect_url}"
    else
      logger.info "line 88, create failed"
    end

  end
end

