module LandingPageHelper
  def correct_path(content)
    if content.is_a? Session
      article_path(content)
    elsif content.is_a? VideoInterview
      video_interview_path(content)
    elsif content.is_a? Announcement
      announcement_path(content)
    end
  end
end
