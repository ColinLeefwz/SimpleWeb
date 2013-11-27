require 'spec_helper'

def login_member
  login_as jevan
end

feature "Member Dashboard" do
  helper_objects

  background do
    login_member
    visit dashboard_member_path(jevan.id)
  end

  scenario "show the list of followed experts", js: true do  
    jevan.follow sameer
    jevan.follow alex
    click_link("Expert")
    expect(page).to have_css(".expert-action-box", count: 2)
  end
end
