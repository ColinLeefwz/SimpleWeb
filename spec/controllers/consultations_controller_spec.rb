require 'spec_helper'

describe ConsultationsController do
  helper_objects

  describe "GET 'new'" do
  end

  describe "GET 'create'" do
    before :each do
      User.delete_all
      post :create, consultation: attributes_for(:consultation, consultant_id: sameer.id, requester_id: peter.id), format: :js
      double(send_consultation_pending_mail: true)
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
