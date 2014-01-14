class WelcomeController < ApplicationController

  def index
    video_interviews = VideoInterview.all
    annoucements = Announcement.all
    articles = Session.where(content_type: "ArticleSession").where(draft: false)
    collection = video_interviews + annoucements + articles
    @sessions = collection.sort{|x, y| y.updated_at <=> x.updated_at}
    @show_category = true
  end

end
