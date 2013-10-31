require 'spec_helper'

def login_admin

end

def login_expert
	sameer.create_expert_profile

	login_as(sameer, scope: :user)
end

feature "Expert Dashboard" do
	helper_objects

	background do
		login_expert
		cate_macro = create(:category, name: "macro")
		cate_tech = create(:category, name: "tech")
		visit dashboard_expert_path(sameer.id)
	end

	scenario "shows all the sessions created by the expert", js: true do
		expect(page).to have_content "sameer"
		expect(page).to have_css ".expert-info"
	end

	scenario "posts new content", js: true do
		click_link("Post new content")
		expect(page).to have_css("form#new_session")

		## fill in the post new content form
		within("form#new_session") do
			fill_in("Title", with: "a new acticle session")
			attach_file("session_cover", File.join( Rails.root.join('spec', 'fixtures', 'about_us.jpg') ))
			check("session_categories_macro")
		end

		## Create post content
		click_button("Create post content")

		expect(current_path).to eq dashboard_expert_path(sameer.id)

		expect(Session.count).to eq 1
	end

end
