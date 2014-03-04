require 'spec_helper'

describe ConsultationsController do
  helper_objects

  describe "GET 'new'" do
  end

  describe "GET 'create'" do
    before :each do
      post :create, consultation: attributes_for(:consultation, consultant_id: sameer, requester_id: peter,)
    end

    it "creates a new consultation" do
      expect(Consultation.count).to eq 1
    end

    it "has the right requester and consultant" do
      expect(assigns[:consultation].requester).to eq peter
      expect(assigns[:consultation].consultant).to eq sameer
    end

    it "sets the consultation's status to 'pending'" do
      expect(assigns[:consultation].status).to eq "pending"
    end
  end

end
