class Enrollment< ActiveRecord::Base
  belongs_to :enrollable, polymorphic: true 
  belongs_to :user

  validates :user_id, :enrollable_id, :enrollable_type, presence: true
  validates :user_id, uniqueness: { scope: [:enrollable_type, :enrollable_id], message: "can not enroll twice" }
end
