require 'spec_helper'

describe Consultation do
  helper_objects

  describe "relationship with users" do
    before :each do
      User.delete_all
      @consultation = create(:consultation,  consultant: sameer,requester: jevan, description: "jevan's consultation to sameer")
    end

    context "member sends consultation" do
      it "requester is the member" do
        expect(@consultation.requester).to eq jevan
      end

      it "the member has the consultation" do
        expect(jevan.sent_consultations).to include @consultation
      end

    end

    context "expert receives consultation" do
      it "consultant is the expert" do
        expect(@consultation.consultant).to eq sameer
      end

      it "the expert has the consultation" do
        expect(sameer.received_consultations).to include @consultation
      end
    end
  end
end
