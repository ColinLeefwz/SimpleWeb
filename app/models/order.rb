require 'paypal-sdk-rest'
include PayPal::SDK::REST

class Order < ActiveRecord::Base
  belongs_to :enrollable, polymorphic: true 
  belongs_to :user

  validates :user_id, :enrollable_id, :enrollable_type, presence: true
  validates :user_id, uniqueness: { scope: [:enrollable_type, :enrollable_id], message: "already purchased" }

  def payment
    @payment ||= payment_id && Payment.find(payment_id)
  end

  def create_payment(item, return_url)
    @payment = PayPal::SDK::REST::Payment.new({
      :intent =>  "sale",
      :payer =>  {
        :payment_method =>  "paypal" },

      :redirect_urls => {
        :return_url => return_url,
        :cancel_url => "http://localhost:3000/" },

      :transactions =>  [{

        :item_list => {
          :items => [{
            :name => item.title,
            :price => '%.2f' % item.price,
            :currency => "USD",
            :quantity => 1 }]
        },

        :amount =>  {
          :total =>  '%.2f' % item.price,
          :currency =>  "USD" },
        :description =>  "This is the payment transaction description." }]
    })

    if @payment.create
      self.payment_id = @payment.id
      self.state      = @payment.state
      save
    else
      raise ActiveRecord::Rollback, "Can't place the order"
    end
  end

  def execute(payer_id)
    if payment.present? and payment.execute(payer_id: payer_id)
      self.state = payment.state
      save
    else
      errors.add :description, payment.error.inspect
      false
    end
  end

  def approve_url
    payment.links.find{|link| link.method == "REDIRECT" }.try(:href)
  end
end
