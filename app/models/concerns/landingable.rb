module Landingable
  extend ActiveSupport::Concern

  included do
    after_save :added_to_landingitems
  end

  protected
  def added_to_landingitems
    Landingitem.add_record(self)
  end
end
