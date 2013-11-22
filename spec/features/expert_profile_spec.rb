require 'spec_helper'

feature "Expert Profile Page" do
	helper_objects

	background do
		[session_intro, session_communication]
		[sameer_profile, alex_profile]
		login_as peter
		visit profile_expert_path(sameer)
	end

	scenario "lists all my sessions", js: true do
		expect(page).to have_css("div.box-header", count: 2)
	end

	context "follow the expert", js: true do
		scenario "follow successfully" do
			page.find("i.fa-star").click
			expect(page).to have_content("Unfollow")
			expect(sameer.reload.followers).to include peter
		end
	end

	context "unfollow the expert", js: true do
		scenario "unfollow successfully" do
			peter.follow sameer
			page.find("i.fa-star").click
			expect(page).to have_content("Follow")
			expect(sameer.reload.followers).not_to include peter
		end
	end
end
