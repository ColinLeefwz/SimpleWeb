class ApplicationDecorator < Draper::Decorator
  def get_tooltip
    tooltips = {"Article" => "article", "VideoInterview" => "interview", "Course" => "course", "Announcement" => "announcement"}

    tooltips[object.class.name]
  end

  def get_image_tag
    images = { "LiveSession" => "livestreaming.png", "Article" => "text.png", "VideoInterview" => "video_interview_icon.png", "Announcement" => "announcement.png", "Course" => "video_course_icon.png" }
    images[object.class.name]
  end
end
