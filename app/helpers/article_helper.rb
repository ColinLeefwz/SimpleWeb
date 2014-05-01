module ArticleHelper
  def determine_time_with_zone(zone=nil, time, fallback)

    if zone.nil?   # if zone is not explicitly specified
      user_timezone = current_user.time_zone if user_signed_in?
      session_timezone = fallback
      zone = user_timezone || session_timezone || "UTC"
    end

    time.in_time_zone(zone).to_formatted_s(:short) + "   " + zone
  end

end
