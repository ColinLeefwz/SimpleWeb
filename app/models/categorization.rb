class Categorization < ActiveRecord::Base
  belongs_to :category
  belongs_to :categoriable, polymorphic: true
end
