require 'spec_helper'

describe Expert do
  helper_objects

  describe ".published_contents" do
    it "lists all non-draft contents" do
      [article, video_interview]
      draft_article = create(:article, draft: true, categories: ["culture"], title: "draft article", expert: sameer)
      expect(sameer.reload.published_contents).not_to include draft_article
    end
  end

end
