require 'spec_helper'

feature "Index", js: true do
  helper_objects

  background do
		[page_about_us, page_faq, page_terms]
  	visit root_path
		## maximize the test FF browser
		window = Capybara.current_session.driver.browser.manage.window
		# window.maximize
		window.resize_to 1280, 800
	end

  scenario "has links of 'about us', 'Faq' and 'For Experts'" do
  	page.should have_link 'About Us'
  	page.should have_link 'FAQ'
  	page.should have_link 'For Experts'
  end

  scenario "goes to 'About us' page when 'About us' link is clicked" do
    page.find_link('About Us').click
    page.should have_content 'About Us'
  end

  scenario "goes to 'Faq' page when 'Faq' link is clicked" do
    page.find_link('FAQ').click
    page.should have_content 'FAQ'
  end

  scenario "goes to 'For Experts' page when 'For Experts' link is clicked" do
    page.find_link('For Experts').click
    page.should have_content 'For Experts'
  end

  scenario "has title 'Prodygia | Home'" do
    page.should have_title 'Prodygia | Home'
  end

end 
