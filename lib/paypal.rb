require 'paypal-sdk-rest'
include PayPal::SDK::REST
include PayPal::SDK::Core::Logging

class Paypal

  class << self

    def create_payment_with_paypal(item, order, execute_url)
      # price = item.price.to_s
      @payment = Payment.new({
        :intent =>  "sale",

        # ###Payer
        # A resource representing a Payer that funds a payment
        # Payment Method as 'paypal'
        :payer =>  {
          :payment_method =>  "paypal" },

          # ###Redirect URLs
          :redirect_urls => {
            :return_url => execute_url,
            :cancel_url => "http://localhost:3000/" },

            # ###Transaction
            # A transaction defines the contract of a
            # payment - what is the payment for and who
            # is fulfilling it.
            :transactions =>  [{

              # Item List
              :item_list => {
                :items => [{
                  :name => item.title,
                  # :sku => "item",
                  :price => '%.2f' % item.price,
                  :currency => "USD",
                  :quantity => 1 }]},

                  # ###Amount
                  # Let's you specify a payment amount.
                  :amount =>  {
                    :total =>  '%.2f' % item.price,
                    :currency =>  "USD" },
                    :description =>  "This is the payment transaction description." }]})


      if @payment.create
        order.update_attributes payment_id: @payment.id

        order.approve_url = @payment.links.find{|v| v.method == "REDIRECT" }.href
      else
      end
    end

  end
end
