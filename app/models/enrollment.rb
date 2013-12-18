class Enrollment< ActiveRecord::Base
  belongs_to :enrollable, polymorphic: true  # belongs to courses and sessions
  belongs_to :user
end
