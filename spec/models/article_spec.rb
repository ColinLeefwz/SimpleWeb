require 'spec_helper'

describe Article do
  helper_objects

  subject {create(:article, expert: sameer, categories: [culture])}

  describe "#non_draft" do
    # before :each do
    #   @article = Article.new
    #   @article.save
    #   subject.save
    # end
    it "returns false" do
      expect(subject.draft).to be_false
    end

    it "should include the subject " do
      expect(Article.non_draft).to include(subject)
    end
  end

  describe "#producers" do
    it "returns a string containing expert name" do
      expect(subject.producers).to eq "by sameer karim"
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
