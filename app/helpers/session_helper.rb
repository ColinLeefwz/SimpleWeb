module SessionHelper
  def get_image_tag(session)
    images = { "LiveSession" => "livestreaming.png", "ArticleSession" => "text.png", "VideoSession" => "video.png", "Announcement" => "announcement.png" }
    images[session.class.to_s]
  end
end
