class WelcomeController < ApplicationController
  

  def index
    #TODO => Retrieving Multiple Objects in Batches
    # @sessions = Session.all
    @sessions = Session.all
  end
  
  def contact
  end
  
  def faq
  end

  def for_experts
  end

  def for_members
  end

  def privacy
  end

  def terms
  end 

end
