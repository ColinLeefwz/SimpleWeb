require 'spec_helper'

describe User do
	describe ".enroll_session" do
		it "adds a session to user's enrolled_sessions" do
			expert = FactoryGirl.create(:expert, email: 'expert@test.com', password: '11111111', first_name: 'peter', last_name: 'zhao')
			session = FactoryGirl.create(:session, title: 'test session', expert: expert)
			allen = FactoryGirl.create(:user, email: 'allen@test.com', password: '11111111', first_name: 'allen', last_name: 'wang' )
			allen.enroll_session session
			expect(allen.enrolled_sessions.count).to eq 1
		end

	end
end
