class WelcomeController < ApplicationController

  def index
    @sessions = Session.where.not(content_type: 'LiveSession').where("draft=false").order("always_show desc, created_at desc").to_a
    @sessions.concat VideoInterview.order("updated_at desc").to_a
  end

end
