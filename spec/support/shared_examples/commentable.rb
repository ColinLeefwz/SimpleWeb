
shared_examples "commentable" do |type|
  before(:each) do
    commentable = create(type)
    commenter = create(:member)
    @comment = create(:comment, commentable: commentable , user: commenter, content: "first comment")
    login_as commenter
    visit(polymorphic_path commentable)
  end

  it "list all the comments" do
    expect(page.find(".comments h4")).to have_content("1")
    expect(page).to have_css(".comment", count: 1)
  end

  it "display newly posted comment", js: true do
    within("#new_comment") do
      fill_in("comment[content]", with: "newly posted comment")
      page.find(".comment-btn").click
    end

    expect(page).to have_css(".comment", count: 2)
    expect(page).to have_content("newly posted comment")
  end

  it "can be deleted by its creator", js: true do
    expect(page).to have_content("first comment")
    within("#comment_#{@comment.id}") do
      click_link "delete"
      page.driver.browser.switch_to.alert.accept
    end
    expect(page).not_to have_content("first comment")
    expect(page.find(".comments h4")).to have_content("0")
  end

end
