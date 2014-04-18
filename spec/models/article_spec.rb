require 'spec_helper'

describe Article do
  helper_objects

  describe "#non_draft" do
    let(:draft_article) { create(:article, title: 'draft article', expert: sameer, description: 'draft', categories: [culture], draft: true)}

    it "returns an array include non draft articles" do
      article_array = create_list(:article, 5, expert: sameer, categories: [culture])
      expect(Article.non_draft).to match_array article_array
    end

    it "returns an array of articles without draft ones" do
      article
      expect(Article.non_draft).not_to include(draft_article)
    end
  end

  describe "#producers" do
    it "returns a string containing expert name" do
      expect(article.producers).to eq "by sameer karim"
    end
  end

  describe ".update_landing_order(order)" do
    it "updates its order in landing page" do
      article.update_landing_order(1)
      expect(Landingitem.first.reload.num).to eq 1
    end

    it "default to be nil" do
      article
      expect(Landingitem.first.reload.num).to be_nil
    end
  end
end
