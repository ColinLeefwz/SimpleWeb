require 'spec_helper'

feature "Index" do 
  #helper_objects
  
  background do
  	visit welcome_index_path
  end	

  scenario "has links of 'about us', 'sessions' and 'experts'" do 
  	page.should have_link 'About us'
  	page.should have_link 'Sessions'
  	page.should have_link 'Experts'
  end 

  scenario "goes to 'About us' page when 'About us' link is clicked" do
    page.find_link('About us').click
    page.should have_content 'About us'
  end

  scenario "goes to 'Sessions' page when 'Sessions' link is clicked" do
    page.find_link('Sessions').click
    page.should have_content 'Sessions'
  end

  scenario "goes to 'Experts' page when 'Experts' link is clicked" do
    page.find_link('Experts').click
    page.should have_content 'Experts'
  end

  scenario "has 3 tables and eache table has 2 'tr'" do
  	expect(all('table').count).to eq 3
    expect(all('tr').count).to eq 6
  end	

  scenario "goes to responding session's page when the relative image is clicked" 
end 
