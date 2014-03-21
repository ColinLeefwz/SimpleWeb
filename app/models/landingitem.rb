class Landingitem < ActiveRecord::Base
  belongs_to :expert

  class << self
    def add_record(obj)
      if obj.class.name == "Course"
        obj.experts.each do |exp|
          create(landingable_type: obj.class.name,
                             landingable_id: obj.id,
                             updated_at: obj.updated_at,
                             created_at: obj.created_at,
                             only_index: false,
                             expert: exp)
        end
      else
        create(landingable_type: obj.class.name,
                           landingable_id: obj.id,
                           updated_at: obj.updated_at, 
                           created_at: obj.created_at,
                           only_index: true,
                           expert: obj.expert)
      end
    end

    def all_index_items(start_point)
      all_items = []
      start = start_point * 10
      where(only_index: true).order(updated_at: :desc).limit(12).offset(start).each do |item|
        all_items << item.landingable_type.constantize.find(item.landingable_id)
      end
      all_items
    end
  end

end
