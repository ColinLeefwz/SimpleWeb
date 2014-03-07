class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true

  scope :visible, -> {where(soft_deleted: false)}
end
