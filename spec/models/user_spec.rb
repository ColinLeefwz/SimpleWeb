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

	describe ".followers" do
		it "lists all the users who followed me" do
			pending "should we add the method"
		end
	end
end
