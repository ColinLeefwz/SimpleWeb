class ApplicationDecorator < Draper::Decorator
  def get_tooltip
    tooltips = {"Article" => "article", "VideoInterview" => "interview", "Course" => "course", "Announcement" => "announcement"}

    tooltips[object.class.name]
  end
end
