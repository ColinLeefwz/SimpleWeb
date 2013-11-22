require 'spec_helper'

describe UsersController do
	helper_objects

	describe "GET relationship" do

		context "logged in member" do
			before :each do
				sign_in peter
			end

			it "can follow the expert" do
				get :relationship, the_followed: sameer.id, format: :js
				expect(sameer.followers).to include peter
			end

			it "can unfollow the expert if already follow the expert" do
				sameer.followers << peter
				get :relationship, the_followed: sameer.id, format: :js
				expect(sameer.reload.followers.map &:id).not_to include peter.id
			end
		end
	end

end
