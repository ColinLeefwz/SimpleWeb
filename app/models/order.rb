class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :session

	attr_accessor :return_url, :cancel_url, :payment_method, :approve_url

end
