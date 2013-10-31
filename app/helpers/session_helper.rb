module SessionHelper
  def get_image_tag(session)
    images = { "LiveSession" => "livestreaming.png", "ArticleSession" => "text.png", "VideoSession" => "video.png", "Announcement" => "announcement.png" }
    images[session.class.to_s]
  end

  def get_box_class(session)
    box_class = " item "+session.categories.join(" ")+" "
    box_class += session.content_type if session.content_type
    box_class += " always_show" if session.always_show
    
    box_class
  end

  def session_pay_link
    if @include
      "Enrolled!"
    else
      if @free_session
        link_to "Confirm", free_confirm_session_path(@session), class: 'btn'
      else
        link_to image_tag("paypal_button.png"), buy_now_session_path(@session)
      end
    end
  end
  

  def determine_time_with_zone(zone=nil, time, fallback)

    user_timezone = current_user.time_zone if user_signed_in?
    session_timezone = fallback
    zone = user_timezone || session_timezone || "UTC"

    time.in_time_zone(zone).to_formatted_s(:short) + "   " + zone
  end

end
