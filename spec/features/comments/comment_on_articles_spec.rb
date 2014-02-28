require "spec_helper"

feature "comment on article page" do
  helper_objects

  background do
    article = create(:article)
    create(:comment, commentable: article)
    login_as gecko, scope: :user
    visit article_path(article)
  end

  scenario "lists existing comments" do
    expect(page).to have_css(".comments", count: 1)
    expect(page).to have_css(".comment", count: 1)
  end

  scenario "create new comment and expand it to the bottom", js: true do

  end
end
