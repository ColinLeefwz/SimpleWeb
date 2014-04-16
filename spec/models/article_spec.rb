require 'spec_helper'

describe Article do
  helper_objects

  subject {create(:article, expert: sameer, categories: [culture])}

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
