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

  describe "PUT cancel content" do
    context "not logged in" do
      it "can not cancel the session" do
        get :cancel_content, id: session_intro.id, format: :js
        expect(response).to redirect_to root_path
      end

      it "can not make the session to be canceled" do
        get :cancel_content, id: session_intro.id, format: :js
        expect(session_intro.reload).not_to be_canceled
      end
    end

    context "logged in as normal user" do
      before :each do
        sign_in peter
      end

      it "can not cancel the session" do
        get :cancel_content, id: session_intro.id, format: :js
        expect(response).to redirect_to root_path
      end

      it "can not make the session to be canceled" do
        get :cancel_content, id: session_intro.id, format: :js
        expect(session_intro.reload).not_to be_canceled
      end
    end

    context "logged in as the expert" do
      before :each do
        sign_in sameer
      end

      it "can cancel the session" do
        get :cancel_content, id: session_intro.id, format: :js
        expect(response).to be_success
      end

      it "makes the session to be canceled" do
        get :cancel_content, id: session_intro.id, format: :js
        expect(session_intro.reload).to be_canceled
      end

      it "shows all the un-canceled sessions" do
        get :cancel_content, id: session_intro.id, format: :js

        result = false
        assigns[:sessions].each do |session|
          result = result || session.canceled
        end

        expect(result).to be_false
      end
    end
  end

end
