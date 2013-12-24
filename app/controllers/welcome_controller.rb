class WelcomeController < ApplicationController

  def index
    video_interviews = VideoInterview.all.to_a
    annoucements = Announcement.all.to_a
    articles = Session.where(content_type: "ArticleSession").where(draft: false).to_a
    collection = []
    collection << video_interviews
    collection << annoucements
    collection << articles
    @sessions = collection.flatten.sort{|x, y| y.updated_at <=> x.updated_at}
    @show_category = true
  end

end
