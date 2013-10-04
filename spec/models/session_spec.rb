require 'spec_helper'

describe Session do
	helper_objects

	describe ".is_free?" do
		it "true if the price equals 0.00" do
			session_intro.price = 0.00
			expect(session_intro.is_free?).to be_true
		end

		it "true if the price is less than 0.00" do
			session_intro.price = -3.00
			expect(session_intro.is_free?).to be_true
		end

		it "false if the price is bigger than 0.00" do
			session_intro.price = 5.00
			expect(session_intro.is_free?).to be_false
		end

	end
end
