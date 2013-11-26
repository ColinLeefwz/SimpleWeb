require 'spec_helper'

describe User do
	helper_objects

	describe ".enroll_session" do
		it "adds a session to user's enrolled_sessions" do
			allen.enroll_session session_find
			allen.enroll_session session_map
			expect(allen.enrolled_sessions.count).to eq 2
		end
	end

	describe ".follow?" do
		it "returns true if already followed me" do
			peter.followers << allen
			expect(allen.follow? peter).to be_true
		end

		it "returns false if not followed me" do
			expect(allen.follow? peter).to be_false
		end
	end

	describe ".follow" do
		it "follows the followed one" do
			peter.follow allen
			expect(peter.reload.followed_users).to include allen
		end
	end

	describe ".unfollow" do
		it "un-follows the followed one" do
			peter.followers << allen
			allen.unfollow peter
			expect(peter.reload.followers).not_to include allen
		end
	end
end
