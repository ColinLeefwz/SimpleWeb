class Course < ActiveRecord::Base
  validates :title, presence: true

  has_and_belongs_to_many :experts
  has_many :chapters, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: lambda{|c| c[:title].blank?}, allow_destroy: true
end
