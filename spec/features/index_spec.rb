require 'spec_helper'

feature "Index", js: true do
  helper_objects
  
  background do
		[page_about_us, page_faq, page_terms]
  	visit root_path
		## TODO: because of the responsive page, the page of the default driver
		# can only show the select, but not the words in the page.
		# so, need to find way to make the browser to full screen
  end	

  scenario "has links of 'about us', 'Faq' and 'Terms'" do 
  	page.should have_link 'About us'
  	page.should have_link 'Faq'
  	page.should have_link 'Terms'
  end 

  scenario "goes to 'About us' page when 'About us' link is clicked" do
    page.find_link('About us').click
    page.should have_content 'About us'
  end

  scenario "goes to 'Faq' page when 'Faq' link is clicked" do
    page.find_link('Faq').click
    page.should have_content 'Faq'
  end

  scenario "goes to 'Terms' page when 'Terms' link is clicked" do
    page.find_link('Terms').click
    page.should have_content 'Terms'
  end

end 
