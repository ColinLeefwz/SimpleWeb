class WelcomeController < ApplicationController
  def index
  	#TODO => Retrieving Multiple Objects in Batches
  	@prodygia_picks = Session.where('status' => 'Prodygia Picks')
  	@scheduled = Session.where('status' => 'Scheduled')
  	@upcoming = Session.where('status' => 'Upcoming')
  end
end
