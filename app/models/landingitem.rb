class Landingitem < ActiveRecord::Base
  TOOL_TIPS = {"Article" => "article", "VideoInterview" => "interview", "Course" => "course", "Announcement" => "announcement"}.freeze
  IMAGE_TAGS = { "LiveSession" => "livestreaming.png", "Article" => "text.png", "VideoInterview" => "video_interview_icon.png", "Announcement" => "announcement.png", "Course" => "video_course_icon.png" }.freeze

  belongs_to :expert

  class << self
    def add_record(obj)
      if obj.class.name == "Course"
        obj.experts.each do |exp|
          create(landingable_type: obj.class.name,
                             landingable_id: obj.id,
                             updated_at: obj.updated_at,
                             created_at: obj.created_at,
                             draft: obj.draft,
                             expert: exp)
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

    ## Peter at 2014-04-17: used for batch load items
    #  not used until the "load more" function works
    # def all_index_items(start_point)
    #   all_items = []
    #   start = start_point * 12
    #   where(draft: false).select(:landingable_id, :landingable_type, :updated_at).uniq.order(updated_at: :desc).limit(12).offset(start).each do |item|
    #     all_items << item.fetch_object
    #   end
    #   all_items
    # end

    def next(start_point)
      @max_count = where(draft: false).count
      ((start_point * 12) > @max_count) ? false : true
    end
  end

  def fetch_object
    self.landingable_type.constantize.find(self.landingable_id)
  end

end
