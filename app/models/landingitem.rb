class Landingitem < ActiveRecord::Base
  belongs_to :expert

  class << self
    def add_record(obj)
      if obj.class.name == "Course"
        obj.experts.each do |exp|
          unless exp.is_staff
            create(landingable_type: obj.class.name,
                               landingable_id: obj.id,
                               updated_at: obj.updated_at,
                               created_at: obj.created_at,
                               draft: obj.draft,
                               expert: exp)
          end
        end
      else
        create(landingable_type: obj.class.name,
                           landingable_id: obj.id,
                           updated_at: obj.updated_at, 
                           created_at: obj.created_at,
                           draft: obj.draft,
                           expert: obj.expert)
      end
    end

    def update_record(obj)
      Landingitem.find_by(landingable_type: obj.class.name, landingable_id: obj.id).update_attributes(updated_at: obj.updated_at, draft: obj.draft)
    end

    def all_index_items(start_point)
      all_items = []
      start = start_point * 12
      # where(only_index: true, draft: false).order(updated_at: :desc).limit(12).offset(start).each do |item|
      where(draft: false).order(updated_at: :desc).limit(12).offset(start).each do |item|
        all_items << item.landingable_type.constantize.find(item.landingable_id)
      end
      all_items
    end

    def next(start_point)
      @max_count = where(only_index: true, draft: false).count
      ((start_point * 12) > @max_count) ? false : true
    end
  end

end
