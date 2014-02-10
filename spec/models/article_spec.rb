require 'spec_helper'

describe Article do
  helper_objects

  it { should belong_to(:expert) }

  describe "canceled" do
    it "can be canceled" do
      article = create(:article, title: "test", expert: sameer, categories: ["test"])
      article.update_attributes canceled: true
      expect(article.reload).to be_canceled
    end
  end

end
