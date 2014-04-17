require 'spec_helper'

describe LandingitemQuery do
  helper_objects

  describe "#all_items" do
    it "lists all items, including Staff's" do
      [article, video_interview, announcement, course_staff, first_course]
      expect(LandingitemQuery.all_items).to match_array([article, video_interview, announcement, course_staff, first_course])
    end
  end

  describe "#all_without_staff" do

  end

end
