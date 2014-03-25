module ActAsCategoriable
  extend ActiveSupport::Concern

  included do 
    has_many :categorizations, as: :categoriable
    has_many :categories, through: :categorizations
  end

  def category_names
    categories.pluck(:name).join(', ')
  end
end
