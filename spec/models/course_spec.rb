require 'spec_helper'

describe Course do
  helper_objects

  describe "#recommended_courses" do
    before :each do
      Expert.delete_all
      @courses = create_list(:course, 5, title: "course", experts: [sameer], categories: ["culture"])
      @staff_course = create(:course, title: "staff course", experts: [staff], categories: ["culture"])
    end

    context "current user is member" do
      it "excludes the Staff's courses" do
        expect(Course.recommend_courses(jevan)).not_to include @staff_course
      end

      it "has 3 items" do
        expect(Course.recommend_courses(jevan)).to have(3).items
      end

      it "excludes my subscribed courses" do ## Peter at 2014-02-26: here subscribed eq enrolled for old uses
        Course.delete_all
        enrolled_course = create(:course, title: "subscribed course", experts: [sameer], categories: ["culture"])
        courses = create_list(:course, 2, title: "course", experts: [sameer], categories: ["culture"])
        staff_course = create(:course, title: "staff course", experts: [staff], categories: ["culture"])
        jevan.enroll enrolled_course
        expect(Course.recommend_courses(jevan)).not_to include enrolled_course
        expect(Course.recommend_courses(jevan).count).to eq 2
      end
    end

    context "current user is an expert" do
      it "shows Staff's courses to experts" do
        expect(Course.recommend_courses(sameer)).to include @staff_course
        expect(Course.recommend_courses(sameer)).to have(1).course
      end

      it "excludes his own courses" do
        expect(Course.recommend_courses(sameer)).not_to include @courses
      end
    end
  end

  describe "expert should auto enroll his own courses" do
    it "enrolled his own course after create the course" do
      first_course
      expect(sameer.enrolled_courses).to include first_course
    end
  end

end
