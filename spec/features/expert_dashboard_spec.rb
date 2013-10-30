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
		visit dashboard_expert_path(sameer.id)
	end

	scenario "shows all the sessions created by the expert", js: true do
		expect(page).to have_content "sameer"
		expect(page).to have_css ".expert-info"
	end

end
