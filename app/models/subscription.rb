class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: "User"
  belongs_to :subscribable, polymorphic: true

  validates :subscriber, presence: true
end
