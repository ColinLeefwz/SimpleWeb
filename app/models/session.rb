class Session < ActiveRecord::Base
  belongs_to :expert

  has_attached_file :cover
end
