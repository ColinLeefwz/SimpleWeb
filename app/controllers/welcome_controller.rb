class WelcomeController < ApplicationController

  def index
    @sessions = Session.where("draft=false").order("always_show desc, created_at desc")
  end

end
