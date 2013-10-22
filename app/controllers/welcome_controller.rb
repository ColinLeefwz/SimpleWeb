class WelcomeController < ApplicationController

  def index
    @sessions = Session.where("draft=false")
  end

end
