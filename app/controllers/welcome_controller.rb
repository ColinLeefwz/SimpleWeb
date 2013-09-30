class WelcomeController < ApplicationController

  def index
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
end
