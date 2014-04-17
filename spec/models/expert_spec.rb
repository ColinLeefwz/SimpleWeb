require 'spec_helper'

describe Expert do
  helper_objects

  describe ".published_contents" do
    it "lists all non-draft contents" do
      [article, video_interview]
      draft_article = create(:article, draft: true, categories: [culture], title: "draft article", expert: sameer)
      expect(sameer.reload.published_contents).not_to include draft_article
    end
  end

  describe ".fetch_contents" do
    before :each do
      [article, video_interview]
      @draft_article = create(:article, draft: true, categories: [culture], title: "draft article", expert: sameer)
    end

    it "lists all if there's no option" do
      expect(sameer.send :fetch_contents).to include @draft_article
    end

    it "lists non-draft articles if given the option" do
      expect(sameer.send :fetch_contents, { draft: false }).not_to include @draft_article
    end
  end

  describe ".all_profile_items" do
    it "lists Article, Announcement, Courses, Video_interview belongs to this expert" do
      [article, announcement_sameer, first_course, video_interview]
      expect(sameer.all_profile_items).to match_array([article, announcement_sameer, first_course, video_interview])
    end
  end

end
