class Category < ActiveRecord::Base
  has_many :categorization

  has_many :articles, through: :categorization, source: :categoriable, source_type: "Article"
  has_many :video_interviews, through: :categorization, source: :categoriable, source_type: "VideoInterview"
  has_many :announcements, through: :categorization, source: :categoriable, source_type: "Announcement"
  has_many :courses, through: :categorization, source: :categoriable, source_type: "Course"

  delegate :count, to: :categorization
end
