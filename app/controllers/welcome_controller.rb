class WelcomeController < ApplicationController

  def index
    video_interviews = VideoInterview.includes(:expert)
    annoucements = Announcement.includes(:expert)
    articles = ArticleSession.includes(:expert).where(draft: false)
    collection = video_interviews + annoucements + articles
    @sessions = collection.sort{|x, y| y.updated_at <=> x.updated_at}
    @show_category = true
  end

end
