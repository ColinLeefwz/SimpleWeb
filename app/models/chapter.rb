class Chapter < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :course
  has_many :sections, dependent: :destroy
  accepts_nested_attributes_for :sections, reject_if: lambda{|s| s[:title].blank?}, allow_destroy: true
end
