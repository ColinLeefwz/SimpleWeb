class WelcomeController < ApplicationController
  

  def index
  	@sessions = Session.all
  end

end
