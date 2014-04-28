require 'spec_helper'

describe ArticleDecorator do
  helper_objects

  describe "#get_favorite_type" do
    it "returns 'content'" do
      article
      expect(article.decorate.get_favorite_type).to eq 'content'
    end
  end

  describe "#comment_counting" do
    it "returns 'Be the first to comment'" do
      article
      expect(article.decorate.comment_counting).to eq 'Be the first to comment'
    end
  end

  describe "#get_tooltip" do
    it "returns 'article'" do
      article
      expect(article.decorate.get_tooltip).to eq 'article'
    end
  end

  describe "#get_image_tag" do
    it "returns 'article.png'" do
      article
      expect(article.decorate.get_image_tag).to eq 'text.png'
    end
  end

  describe "#get_box_class" do
    it "returns the box class information without 'always_show'" do
      article
      expect(article.decorate.get_box_class).to eq ' item culture article'
    end

    it "returns the box class information 'always_show'" do
      article
      article.update_attributes(always_show: 'true')
      expect(article.decorate.get_box_class).to eq ' item culture article always_show'
    end
  end
end
