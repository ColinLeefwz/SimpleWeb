require 'spec_helper'

describe SessionsController do
	helper_objects

	describe "GET 'enroll'" do
		context "logged in as guest"

		context "logged in as member" do
			before :each do
				sign_in peter
				get :enroll, id: session_intro.id
			end

			it "renders the enroll page" do
				expect(response).to render_template 'enroll'
			end

			it "assigns the session" do
				expect(assigns[:session]).to eq session_intro
			end

		end
	end


end
