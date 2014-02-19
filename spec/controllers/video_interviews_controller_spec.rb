require 'spec_helper'

describe VideoInterviewsController do
  helper_objects

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', id: video_interview.id
      response.should be_success
    end

    it "assigns the video_interview" do
      get 'show', id: video_interview.id
      expect(assigns[:video_interview]).to eq video_interview
    end
  end

end
