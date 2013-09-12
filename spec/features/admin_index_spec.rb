require 'spec_helper'

feature 'Admin_index' do
  
  background do
    visit admin_index
  end	

  scenario "The page should have 5 buttons"
end