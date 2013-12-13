class Course < ActiveRecord::Base
  validates :title, presence: true

  has_and_belongs_to_many :experts
  has_many :chapters, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: lambda{|c| c[:title].blank?}, allow_destroy: true

  has_attached_file :cover,
    storage: :s3,
    s3_credentials: {
      bucket: ENV["AWS_BUCKET"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    },
    path: ":class/:attachment/:id/:style/:filename",
    styles: {

    }
end
