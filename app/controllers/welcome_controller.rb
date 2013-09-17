class WelcomeController < ApplicationController
  

  def index
    #TODO => Retrieving Multiple Objects in Batches
    # @sessions = Session.all
    @sessions = Session.all
  end
  
  def about_us
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

  def video_page
    @session = Session.find(params[:id])
  end

  def text_page
    @session = Session.find(params[:id])
  end
end
