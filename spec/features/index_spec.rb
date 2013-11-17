require 'spec_helper'

feature "Index", js: true do
  helper_objects
  
  background do
		[page_about_us, page_faq, page_terms]
  	visit root_path
		
		## maximize the test FF browser
		window = Capybara.current_session.driver.browser.manage.window
		window.maximize
  end	

  scenario "has links of 'about us', 'Faq' and 'Terms'" do 
  	page.should have_link 'About Us'
  	page.should have_link 'FAQ'
  	page.should have_link 'Terms'
  end 

  scenario "goes to 'About us' page when 'About us' link is clicked" do
    page.find_link('About Us').click
    page.should have_content 'About Us'
  end

  scenario "goes to 'Faq' page when 'Faq' link is clicked" do
    page.find_link('FAQ').click
    page.should have_content 'FAQ'
  end

  scenario "goes to 'Terms' page when 'Terms' link is clicked" do
    page.find_link('Terms').click
    page.should have_content 'Terms'
  end

end 
