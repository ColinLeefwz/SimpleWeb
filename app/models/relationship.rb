class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed_user, class_name: "User", foreign_key: "followed_id"
end
