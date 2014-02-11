class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: "User"
  validates :subscriber, presence: true
  belongs_to :subscribable, polymorphic: true
end
