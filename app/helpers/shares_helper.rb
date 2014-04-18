
module SharesHelper

  def copyright_notice_year_range(start_year)
    start_year = start_year.to_i

    current_year = Time.new.year

    if current_year > start_year
      "#{start_year} - #{current_year}"
    else
      "#{current_year}"
    end
  end

  def model_count(klazz)
    if klazz == "Course"
      if current_user.is_a? Expert
        Course.all.count
      else
        Course.all_without_staff.count
      end
    elsif klazz == "Article"
      Article.non_draft.count
    else
      klazz.constantize.count
    end
  end

  def all_count
    all_count = 0
    %w{Article VideoInterview Announcement Course}.each do |klazz|
      all_count += model_count(klazz)
    end
    all_count
  end

end
