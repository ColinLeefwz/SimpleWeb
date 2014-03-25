module ActAsCategoriable
  extend ActiveSupport::Concern

  included do 
    has_many :categorizations, as: :categoriable
    has_many :categories, through: :categorizations
  end

end
