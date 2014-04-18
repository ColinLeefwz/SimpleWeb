require 'spec_helper'

describe WelcomeController do
  helper_objects

  describe 'GET index' do
    before :each do
      [sameer, staff]
      course_staff
      article.update_attributes created_at: Date.today
      announcement.update_attributes created_at: 1.days.ago
      video_interview.update_attributes created_at: 3.days.ago
    end

    context "signed in as Expert" do
      before :each do
        sign_in sameer
      end

      it "assigns all items to landing page, including Staff's courses" do
        get :index
        expect(assigns[:items]).to include course_staff
      end
    end

    context "signed in as Member" do
      before :each do
        sign_in peter
      end

      it "assigns all items to landing page, without Staff's courses" do
        get :index
        expect(assigns[:items]).not_to include course_staff
      end
    end

    it "excludes the Staff's courses" do
      staff_course = create(:course, experts: [staff], title: "staff course", categories: [culture])
      get :index
      expect(assigns[:items]).not_to include staff_course
    end
  end
end
