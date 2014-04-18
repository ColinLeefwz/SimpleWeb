class LandingitemQuery

  def initialize(landingitems = Landingitem.all)
    @items = landingitems
  end

  def all_items
    all_items = []
    get_all_raw_data.each do |item|
      all_items << item.fetch_object
    end
    all_items
  end

  def all_without_staff
    all_items = []
    get_all_raw_data.each do |item|
      obj = item.fetch_object
      all_items << obj unless obj.is_staff_course?
    end
    all_items
  end

  private
  def get_all_raw_data
    @items.where(draft: false).select(:landingable_id, :landingable_type, :updated_at, :num).uniq.order(num: :asc, updated_at: :desc)
  end

end
