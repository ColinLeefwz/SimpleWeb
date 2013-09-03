class WelcomeController < ApplicationController
  

  def index
    #TODO => Retrieving Multiple Objects in Batches
    # @sessions = Session.all
    @sessions = Session.all
  end
  
  def about_us
  end
  
  def blog
  end

  def experts_list
  end

  def faq
  end

  def terms
  end

  def privacy
  end 

end
