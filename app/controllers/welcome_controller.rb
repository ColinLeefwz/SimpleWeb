class WelcomeController < ApplicationController

  def index
    # @sessions = Session.where.not(content_type: 'LiveSession').where.not(content_type: "VideoSession").where("draft=false").order("always_show desc, created_at desc").to_a
    # @sessions.concat VideoInterview.order("updated_at desc").to_a
		@sessions = VideoInterview.all.concat Announcement.all
  end

end
