require 'spec_helper'

describe WelcomeController do
  helper_objects

  describe 'GET index' do
    before :each do
      [sameer, staff]
      article.update_attributes created_at: Date.today
      announcement.update_attributes created_at: 1.days.ago
      video_interview.update_attributes created_at: 3.days.ago
    end

    it "assigns landing items" do
      landing_items = [video_interview, announcement, article]
      get :index
      expect(assigns[:items]).to eq landing_items
    end

    it "excludes the Staff's courses" do
      staff_course = create(:course, experts: [staff], title: "staff course", categories: [culture])
      get :index
      expect(assigns[:items]).not_to include staff_course
    end
  end
end
