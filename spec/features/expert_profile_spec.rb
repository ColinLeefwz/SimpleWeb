require 'spec_helper'

feature "Expert Profile Page" do
  helper_objects

  background do
    create(:course, experts: [sameer])
    create(:article, expert: sameer)
    create(:video_interview, expert: sameer)
    login_as gecko, scope: :user
    visit profile_expert_path(sameer)
  end

  scenario "lists all my contents and courses" do
    expect(page).to have_css("div.box-header", count: 3)
  end

  scenario "follow the expert", js: true do
    page.find("#follow a").click
    expect(page).to have_css(".solid-star-icon", count: 1)
    expect(page.find("#follower-count")).to have_content("1")

    page.find("#follow a").click
    expect(page).to have_css(".hollow-star-icon", count: 3) # cause course box doesn't have star now
    expect(page.find("#follower-count")).to have_content("0")
  end
end
