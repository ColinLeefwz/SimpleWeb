require 'spec_helper'

feature "edit profile" do
  helper_objects

  background js: true do
    login_as(sameer, scope: :user)
    visit dashboard_expert_path(sameer)
    click_link("edit profile")
  end

  scenario "edit profile", js: true do
    within("form.edit_expert") do
      fill_in("expert[first_name]", with: "gecko")
      fill_in("expert[last_name]", with: "fu")
      attach_file("expert[avatar]", File.join( Rails.root.join('spec', 'fixtures', 'account.png') ))

      fill_in("profile[title]", with: "engineer")
      fill_in("profile[company]", with: "Originate")
      select("Hong Kong", from: "profile[country]")
      fill_in("profile[city]", with: "HangZhou")
      select("(GMT-10:00) Hawaii", from: "expert[time_zone]")
      fill_in("profile[twitter]", with: "Gecko")
      fill_in("profile[web_site]", with: "github.io")
      click_button("Update")
    end

    expect(page).to have_content("Welcome to your Expert Dashboard")
    expect(page.find(".expert-name")).to have_content("gecko fu", count: 1)
    expect(page.find(".expert-avatar")).to have_css("img")
    expect(page.find(".expert-text-info")).to have_content("engineer, Originate")
  end

end
