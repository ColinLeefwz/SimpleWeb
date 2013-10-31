require 'spec_helper'

def login_admin

end

def login_expert
	sameer.create_expert_profile

	login_as(sameer, scope: :user)
end

def fill_post_new_content
	within("form#new_article_session") do
		fill_in("Title", with: "a new article session")
		attach_file("article_session_cover", File.join( Rails.root.join('spec', 'fixtures', 'about_us.jpg') ))
		check("article_session_categories_macro")
	end

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

	## post new content
	scenario "posts new content", js: true do
		click_link("Post new content")
		expect(page).to have_css("form#new_article_session")

		## fill in the post new content form
		fill_post_new_content

		## Create post content
		click_button("Submit")

		expect(current_path).to eq dashboard_expert_path(sameer.id)
		expect(page).to have_css(".session-items .item", count: 1)

		expect(Session).to have(1).instance

	end

	scenario "draft a new content", js: true do
		click_link("Post new content")
		expect(page).to have_css("form#new_article_session")

		## fill in the post new content form
		fill_post_new_content

		## Draft it
		click_button "Save Draft"
		expect(current_path).to eq dashboard_expert_path(sameer.id)
		expect(page).to have_css(".session-items .item", count: 1)
		expect(Session).to have(1).instance
		expect(Session.last).to be_draft
	end

	## create new session
	scenario "create new session", js: true do
		click_link "Create new session"
		expect(page).to have_css "form#new_live_session"

		## fill in the form
		within("form#new_live_session") do
			fill_in "live_session_title", with: "new live session"
		end
	end
	

end
