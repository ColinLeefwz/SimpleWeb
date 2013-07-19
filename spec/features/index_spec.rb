require 'spec_helper'

feature "Index" do 
  helper_objects
  
  background do
  	
  	visit welcome_index_path
  end	

  it "should have links of 'about us', 'sessions' and 'experts'" do 
  	page.should have_link 'About us'
  	page.should have_link 'Sessions'
  	page.should have_link 'Experts'
  end 

  it "should jump to 'About us' page when 'About us' link is clicked" do
    page.find_link('About us').click
    page.should have_content 'About us'
  end

  it "should jump to 'Sessions' page when 'Sessions' link is clicked" do
    page.find_link('Sessions').click
    page.should have_content 'Sessions'
  end

  it "should jump to 'Experts' page when 'Experts' link is clicked" do
    page.find_link('Experts').click
    page.should have_content 'Experts'
  end

end 
