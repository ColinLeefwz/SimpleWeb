class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: "User"
  belongs_to :subscribed_session, class_name: "Session"
end
