require 'spec_helper'

describe WelcomeController do
  helper_objects

  describe 'GET index' do
    it "assigns sessions" do
			session_communication.update_attributes created_at: Date.today
			announcement.update_attributes created_at: 1.days.ago
			video_interview.update_attributes created_at: 3.days.ago
			landing_items = [session_communication, announcement, video_interview]
      get :index
      expect(assigns[:sessions]).to eq landing_items
    end
  end
end
