require 'spec_helper'

describe CourseDecorator do
  helper_objects

  describe "#get_favorite_type" do
    it "returns 'content'" do
      course
      expect(course.decorate.get_favorite_type).to eq 'content'
    end
  end

  describe "#comment_counting" do
    it "returns 'Be the first to comment'" do
      course
      expect(course.decorate.comment_counting).to eq 'Be the first to comment'
    end
  end

  describe "#get_tooltip" do
    it "returns 'course'" do
      course
      expect(course.decorate.get_tooltip).to eq 'course'
    end
  end

  describe "#get_image_tag" do
    it "returns 'course.png'" do
      course
      expect(course.decorate.get_image_tag).to eq 'video_course_icon.png'
    end
  end

end
