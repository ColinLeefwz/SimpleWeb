class IntroVideo < ActiveRecord::Base
  belongs_to :introable, polymorphic: true
  has_attached_file :cover
end
