module SessionHelper
  def get_tooltip(item)
    tooltips = {"ArticleSession" => "article", "VideoInterview" => "interview", "Course" => "course", "Announcement" => "announcement"}

    tooltips[item.class.name]
  end
  def get_image_tag(item)
    images = { "LiveSession" => "livestreaming.png", "ArticleSession" => "text.png", "VideoInterview" => "video.png", "Announcement" => "announcement.png", "Course" => "video.png" }
    images[item.class.name]

  end

  def get_box_class(item)
    box_class = " item "+item.categories.join(" ")+" "
    box_class += item.class.name
    box_class += " always_show" if item.try(:always_show)

    box_class.downcase()
  end


  def determine_time_with_zone(zone=nil, time, fallback)

    if zone.nil?   # if zone is not explicitly specified
      user_timezone = current_user.time_zone if user_signed_in?
      session_timezone = fallback
      zone = user_timezone || session_timezone || "UTC"
    end

    time.in_time_zone(zone).to_formatted_s(:short) + "   " + zone
  end

end
