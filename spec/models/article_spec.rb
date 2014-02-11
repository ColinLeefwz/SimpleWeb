require 'spec_helper'

describe Article do
  helper_objects

  subject {create(:article, expert: sameer)}

  describe "#producers" do
    it "returns a string containing expert name" do
      expect(subject.producers).to eq "by sameer karim"
    end
  end
end
