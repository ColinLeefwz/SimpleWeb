class LandingitemQuery
  class << self
    def all_items
      all_items = []
      Landingitem.where(draft: false).select(:landingable_id, :landingable_type, :updated_at, :num).uniq.order(num: :asc, updated_at: :desc).each do |item|
        all_items << item.fetch_object
      end
      all_items
    end
  end
end
