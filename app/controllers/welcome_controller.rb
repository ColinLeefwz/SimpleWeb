class WelcomeController < ApplicationController
  

  def index
    #TODO => Retrieving Multiple Objects in Batches
    # @sessions = Session.all
    @sessions = Session.all
  end
  
  def about_us

  end

end
