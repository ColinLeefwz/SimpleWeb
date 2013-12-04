class Section < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :chapter
end
