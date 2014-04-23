require 'spec_helper'

describe VideoInterviewDecorator do
  helper_objects

  describe "#get_favorite_type" do
    it "returns 'content'" do
      video_interview
      expect(video_interview.decorate.get_favorite_type).to eq 'content'
    end
  end

  describe "#comment_counting" do
    it "returns 'Be the first to comment'" do
      video_interview
      expect(video_interview.decorate.comment_counting).to eq 'Be the first to comment'
    end
  end

  describe "#get_tooltip" do
    it "returns 'video_interview'" do
      video_interview
      expect(video_interview.decorate.get_tooltip).to eq 'interview'
    end
  end

  describe "#get_image_tag" do
    it "returns 'video_interview.png'" do
      video_interview
      expect(video_interview.decorate.get_image_tag).to eq 'video_interview_icon.png'
    end
  end
end
