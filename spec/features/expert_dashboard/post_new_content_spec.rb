require 'spec_helper'

feature "Expert Dashboard" do
  helper_objects

  background do
    login_as(sameer, scope: :user)
    create(:category, name: "macro")
    create(:category, name: "tech")
    visit dashboard_expert_path(sameer)
  end

  context "post new content" do
    background js: true do
      click_link("Post new content")

      within("form#new_article") do
        fill_in("Title", with: "a new article")
        attach_file("session-cover-input", File.join( Rails.root.join('spec', 'fixtures', 'account.png') ))
        check("article_categories_macro")
        check("article_categories_tech")
      end
    end

    ## publish
    scenario "publish new content", js: true do
      click_button("Publish")
      page.driver.browser.switch_to.alert.accept

      within(".main-menu .item") do
        expect(page).to have_content("a new article", count: 1)
      end
      expect(Article).to have(1).instance
    end

    ## draft
    scenario "save an article as draft", js: true do
      click_button "Save Draft"
      page.driver.browser.switch_to.alert.accept

      within(".main-menu .item") do
        expect(page).to have_content("a new article", count: 1)
        expect(page).to have_css(".draft-ribbon", count: 1)
      end
      expect(Article).to have(1).instance
      expect(Article.first).to be_draft
    end

    ## preview
    scenario "preview an article", js: true do
      click_link "Preview"
      expect(page).to have_css("div.modal", :visiable)
      expect(Article).to have(0).instance
    end
  end
end

