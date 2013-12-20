module LandingPageHelper
  def currect_path(session)
    if session.is_a? Session
      session_path(session)
    elsif session.is_a? VideoInterview
      video_interview_path(session)
    elsif session.is_a? Announcement
      announcement_path(session)
    end
  end
end
