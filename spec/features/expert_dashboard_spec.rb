require 'spec_helper'

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

def fill_new_session_form
	## fill in the form
	within("form#new_live_session") do
		fill_in "live_session_title", with: "new live session"
		check "live_session_categories_macro"
		check "live_session_categories_business"
		select "Lounge", from: "live_session_format"
		attach_file("live_session_cover", File.join(Rails.root.join("spec", "fixtures", "Expert_profile.png")))
		## choose a date
		select "Tijuana", from: "live_session_time_zone"
		fill_in "live_session_location", with: "Shanghai"
		fill_in "live_session_price", with: "50"
	end

	## choose date from the datapicker
	page.find("i.icon-calendar").click
	page.find("div.datepicker-days").first(:css, ".day", text: "20").click

end

feature "Expert Dashboard" do
	helper_objects

	background do
		login_expert
		cate_macro = create(:category, name: "macro")
		cate_tech = create(:category, name: "tech")
		cate_business = create(:category, name: "business")
		visit dashboard_expert_path(sameer.id)
	end

	scenario "shows all the sessions created by the expert", js: true do
		expect(page).to have_content "sameer"
		expect(page).to have_css ".expert-info"
	end

	### Post new content
	context "Post new content" do
		background do
			click_link("Post new content")
			expect(page).to have_css("form#new_article_session")
			## fill in the post new content form
			fill_post_new_content
		end

		## post
		scenario "posts new content", js: true do
			click_button("Submit")

			expect(current_path).to eq dashboard_expert_path(sameer.id)
			expect(page).to have_css(".session-items .item", count: 1)

			expect(Session).to have(1).instance

		end

		## draft
		scenario "draft a new content", js: true do
			click_button "Save Draft"

			expect(current_path).to eq dashboard_expert_path(sameer.id)
			expect(page).to have_css(".session-items .item", count: 1)
			expect(Session).to have(1).instance
			expect(Session.last).to be_draft
		end

		## preview
		#TODO: need to use Modal instead opening a new page
		scenario "preview a new content", js: true do
			click_button "Preview"
			expect(page).to have_css("div.text-page-article-box")
			expect(Session).to have(1).instance
			preview_session = Session.last
			expect(current_path).to eq session_path(preview_session)
			expect(preview_session).to be_draft
		end
	end

	### Create new session
	context "Create new session" do
		background do
			click_link "Create new session"
			expect(page).to have_css "form#new_live_session"
			fill_new_session_form
		end

		## create
		scenario "create", js: true do
			click_button "Submit"

			expect(page).to have_css(".session-items .item", count: 1)
			expect(Session).to have(1).instance
		end

		## draft
		scenario "draft", js: true do
			click_button "Save Draft"
			
			expect(page).to have_css(".session-items .item", count: 1)
			expect(Session).to have(1).instance
			expect(Session.last).to be_draft
		end

		scenario "preview", js: true do
			click_button "Preview"
			expect(page).to have_css "div.video-page-info-box"
			preview_session = Session.last
			expect(current_path).to eq session_path(preview_session)
			expect(preview_session).to be_draft
		end
	end
	
	## cancel a session
	scenario "cancel a session created by the expert", js: true do
		session_intro
		click_link "Sessions"
		expect(page).to have_css ".session-items .item"
		session_box = page.find(".session-items .item")
		expect(session_box).to have_link "cancel"

		click_link "cancel"

		expect(page).not_to have_css ".session-items .item"
		expect(session_intro.reload).to be_canceled
	end

end
