require 'spec_helper'

describe Session do
	helper_objects

	describe ".free?" do
		it "true if the price equals 0.00" do
			session_intro.price = 0.00
			expect(session_intro.free?).to be_true
		end

		it "true if the price is less than 0.00" do
			session_intro.price = -3.00
			expect(session_intro.free?).to be_true
		end

		it "false if the price is bigger than 0.00" do
			session_intro.price = 5.00
			expect(session_intro.free?).to be_false
		end
	end

  describe ".set_default" do
    it "set default price to 0.00 for the session" do
      session = create(:session, title: "test", expert: sameer)
      expect(session.price).to eq 0.00
    end
  end

	describe "canceled" do
		it "can be canceled" do
      session = create(:session, title: "test", expert: sameer)
			session.update_attributes canceled: true
			expect(session.reload).to be_canceled
		end
	end
	
end
