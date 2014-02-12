require 'spec_helper'

describe ExpertsController do
  helper_objects

  describe "GET dashboard" do
    context "not logged in" do
      it "can not access the dashboard page" do
        get :dashboard, id: sameer.id
        expect(response).to redirect_to root_path
      end
    end

    context "logged in as member" do
      before :each do
        sign_in peter
      end

      it "can not access the dashboard page" do
        get :dashboard, id: sameer.id
        expect(response).to redirect_to root_path
      end
    end

    context "logged in as expert" do
      before :each do
        sign_in sameer
      end

      it "access his own dashboard page" do
        get :dashboard, id: sameer.id
        expect(response).to render_template "dashboard"
      end

      it "can not access other's dashboard page" do
        get :dashboard, id: alex.id 
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET refer_new_expert" do
    context "not logged in" do
      it "can not access to the refer_new_expert page" do
        get :refer_new_expert, format: :js
        expect(response).not_to be_success
      end

      it "can not assign email_message" do
        get :refer_new_expert, format: :js
        expect(assigns[:email_message]).to be_nil
      end
    end

    context "logged in as member" do
      before :each do
        sign_in peter
      end

      it "can not access the dashboard page" do
        get :refer_new_expert, format: :js
        expect(response).not_to be_success
      end

      it "can not assign email_message" do
        get :refer_new_expert, format: :js
        expect(assigns[:email_message]).to be_nil
      end
    end

    context "logged in as expert" do
      before :each do
        sign_in sameer
      end

      it "access the invite expert page" do
        get :refer_new_expert, format: :js
        expect(response).to be_success 
      end

      it "assigns the email_message" do
        get :refer_new_expert, format: :js
        expect(assigns[:email_message]).to be_new_record
      end
    end
  end

  describe "GET profile" do
    it "shows the expert's profile page" do
      get :profile, id: sameer.id
      expect(response).to be_success
    end

    it "assigns the expert's sessions, video_interviews and courses" do
      [video_interview, session_communication, first_course]
      get :profile, id: sameer.id
      expect(assigns[:items]).to eq [video_interview, first_course, session_communication]
    end

  end


  describe "GET contents" do
    context "not logged in"
    context "logged in as expert" do
      before :each do
        sign_in sameer
      end

      it "get all contents belongs to the expert" do
        [session_intro, session_communication, video_interview]
        get :contents, id: sameer.id, format: :js
        expect(assigns[:items].count).to eq 3
      end
    end
  end

  describe "GET edit profile" do
    context "not logged in" do
      it "can't access edit profile page" do
        get :edit_profile, id: sameer.id, format: :js
        expect(response).to redirect_to root_path
      end
    end

    context "logged in as expert" do 
      before :each do
        sign_in sameer
      end
      it "get the right profile object" do
        get :edit_profile, id: sameer.id, format: :js
        expect(assigns[:profile]).to eq sameer.profile
      end
    end
  end


  describe "PATCH update profile" do
    context "logged in as expert" do
      before :each do
        sameer_profile
        sign_in sameer
      end
      it "update corresponding user profile" do
        patch :update_profile, id: sameer.id, expert: sameer.attributes, profile: attributes_for(:profile, title: "new title"), format: :js
        expect(sameer.reload.profile.title).to eq "new title"
      end
      it "update corresponding user attributes" do
        patch :update_profile, id: sameer.id, expert: attributes_for(:expert, first_name: 'gecko'), profile: sameer.profile.attributes, format: :js
        expect(sameer.reload.first_name).to eq "gecko"
      end
    end
  end
end
