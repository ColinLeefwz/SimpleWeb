require 'spec_helper'

feature "Expert Profile Page" do
	helper_objects

	background do
		[session_intro, session_communication]
		[sameer_profile, alex_profile]
		visit profile_expert_path(sameer)
	end

	scenario "lists all my sessions", js: true do
		expect(page).to have_css("div.box-header", count: 2)
	end
end
