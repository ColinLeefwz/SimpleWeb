require 'spec_helper'

describe UsersController do
	helper_objects

	describe "GET relationship" do
		before :each do
			sign_in peter
		end

		context "logged in member" do
			it "can follow the expert" do
				get :relationship, the_followed: sameer.id, format: :js
				expect(sameer.followers).to include peter
			end
		end
	end

end
