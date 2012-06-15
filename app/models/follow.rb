class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follow, :class_name => "User"

  validates_uniqueness_of :user_id, :if => :has_followed?

  def has_followed?
    Follow.where(["user_id = ? and follow_id = ?", self.user_id, self.follow_id]).any?
  end
  
end
