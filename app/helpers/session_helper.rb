module SessionHelper
  def get_image_tag(item)
    images = { "LiveSession" => "livestreaming.png", "ArticleSession" => "text.png", "VideoInterview" => "video.png", "Announcement" => "announcement.png", "Course" => "video.png" }
		images[item.class.to_s]

  end

  def get_box_class(session)
    box_class = " item "+session.categories.join(" ")+" "
    box_class += session.content_type if session.content_type
    box_class += " always_show" if session.always_show
    
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
