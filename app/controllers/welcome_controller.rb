class WelcomeController < ApplicationController

  def index
		video_interviews = VideoInterview.all.order("updated_at desc").to_a
		announcements = Announcement.all.order("updated_at desc").to_a
		articles = Session.where(content_type: "ArticleSession").where(draft: false).order("always_show desc, updated_at desc").to_a
		@sessions = video_interviews.concat(announcements).concat(articles)
  end

end
