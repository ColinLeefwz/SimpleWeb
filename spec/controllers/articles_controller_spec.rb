require 'spec_helper'

describe ArticlesController do
  helper_objects

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
        result = assigns[:articles].inject(false){|memo, obj| memo || obj.canceled}
        expect(result).to be_false
      end
    end
  end

  ## The Mandrill Key will upload to Circle CI later to pass the tests
  describe "POST email_friend" do
    context "not logged in user"
    context "logged in user" do
      it "construct the email content" do
        post :email_friend, id: session_intro, email_friend: {"your_name"=>"peter", "your_address"=>"peter@originate.com", "to_name"=>"Tina", "to_address"=>"tina@oc.com", "content"=>"some content"}
        expect(assigns[:email]).not_to be_nil
      end
    end
  end


end
