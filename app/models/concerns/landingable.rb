module Landingable
  extend ActiveSupport::Concern

  included do
    after_create :added_to_landingitems
    after_update :update_to_landingitems
  end

  protected
  def added_to_landingitems
    Landingitem.add_record(self)
  end

  def update_to_landingitems
    Landingitem.update_record(self)
  end
end
