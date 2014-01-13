class Visit < ActiveRecord::Base
  belongs_to :visitable, polymorphic: true
  validates :visitable_id, uniqueness: {scope: :visitable_type, message: "duplicate: visitable_id + visitable_type must be unique"}
end
