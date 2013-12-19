class Order < ActiveRecord::Base
  belongs_to :enrollable, polymorphic: true  # belongs to courses and sessions
  belongs_to :user

  validates :user_id, :enrollable_id, :enrollable_type, presence: true
  validates :user_id, uniqueness: { scope: [:enrollable_type, :enrollable_id], message: "already purchased" }

  attr_accessor :return_url, :cancel_url, :payment_method, :approve_url
end
