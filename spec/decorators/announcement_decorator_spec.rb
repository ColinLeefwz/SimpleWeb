require 'spec_helper'

describe AnnouncementDecorator do
  helper_objects

  describe "#get_favorite_type" do
    it "returns 'content'" do
      announcement
      expect(announcement.decorate.get_favorite_type).to eq 'content'
    end
  end

  describe "#comment_counting" do
    it "returns 'Be the first to comment'" do
      announcement
      expect(announcement.decorate.comment_counting).to eq 'Be the first to comment'
    end
  end

  describe "#get_tooltip" do
    it "returns 'announcement'" do
      announcement
      expect(announcement.decorate.get_tooltip).to eq 'announcement'
    end
  end

  describe "#get_image_tag" do
    it "returns 'announcement.png'" do
      announcement
      expect(announcement.decorate.get_image_tag).to eq 'announcement.png'
    end
  end

  describe "#get_box_class" do
    it "returns the box class information without 'always_show'" do
      announcement
      expect(announcement.decorate.get_box_class).to eq ' item culture announcement'
    end

    it "returns the box class information 'always_show'" do
      announcement
      announcement.update_attributes(always_show: 'true')
      expect(announcement.decorate.get_box_class).to eq ' item culture announcement always_show'
    end
  end
end
