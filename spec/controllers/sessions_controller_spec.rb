require 'spec_helper'

describe SessionsController do
	helper_objects

	describe "GET 'enroll'" do
		context "not logged in"

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

  describe "GET show"

  describe "GET edit live sessions" do
    context "not log in"
    context "not log in"
    context "log in as an expert" do
      before :each do
        sign_in sameer
      end

      it "can access the session's edit page" do
        get :edit_live_session, id: session_intro.id, format: :js  
        expect(response).to be_success
      end

      it "assign the session id" do
        get :edit_live_session, id: session_intro.id, format: :js
        expect(assigns[:session]).to eq session_intro
      end

      it "cannot edit other's session" do
        get :edit_live_session, id: session_map.id, format: :js
        expect(response).not_to be_success
      end
    end
  end
end
