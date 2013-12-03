class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: "User"
  validates :subscriber, presence: true
  belongs_to :subscribed_session, class_name: "Session"
  validates :subscribed_session, presence: true
end
