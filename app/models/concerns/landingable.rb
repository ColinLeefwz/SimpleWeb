module Landingable
  extend ActiveSupport::Concern

  included do
    after_create :added_to_landingitems
    after_update :update_to_landingitems
  end

  def update_landing_order(order=nil)
    landing_item = Landingitem.find_by(landingable_id: self.id, landingable_type: self.class.name)
    landing_item.update_attributes num: order
  end

  def is_staff_course?
    (self.is_a? Course) && (self.experts.include? Expert.staff)
  end

  protected
  def added_to_landingitems
    Landingitem.add_record(self)
  end

  def update_to_landingitems
    Landingitem.update_record(self)
  end
end
