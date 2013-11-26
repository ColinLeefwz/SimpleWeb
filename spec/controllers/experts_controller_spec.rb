require 'spec_helper'

describe ExpertsController do
  helper_objects

  describe "GET dashboard" do
    context "not logged in" do
      it "can not access the dashboard page" do
        get :dashboard, id: sameer.id
        expect(response).to redirect_to root_path
      end

      it "can not assign sessions" do
        get :dashboard, id: sameer.id
        expect(assigns[:sessions]).to be_nil
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

      it "can not assign sessions" do
       get :dashboard, id: sameer.id
        expect(assigns[:sessions]).to be_nil
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

      it "assigns sessions" do
        get :dashboard, id: sameer.id
        expect(assigns[:sessions]).to eq sameer.sessions_with_draft
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
        get :refer_new_expert, id: sameer.id, format: :js
        expect(response).not_to be_success
      end

      it "can not assign email_message" do
        get :refer_new_expert, id: sameer.id, format: :js
        expect(assigns[:email_message]).to be_nil
      end
    end

    context "logged in as member" do
      before :each do
        sign_in peter
      end

      it "can not access the dashboard page" do
        get :refer_new_expert, id: sameer.id, format: :js
        expect(response).not_to be_success
      end

      it "can not assign email_message" do
        get :refer_new_expert, id: sameer.id, format: :js
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


  describe "GET contents" do
    context "not logged in"
    context "logged in as expert" do
      before :each do
        sign_in sameer
      end

      it "get all contents belongs to the expert" do
        get :contents, id: sameer.id, format: :js

        expect(assigns[:sessions].count).to eq sameer.contents.count
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
       patch :update_profile, id: sameer.id, profile: attributes_for(:profile, title: "new title"), format: :js
       expect(sameer.profile.title).to eq "new title"
     end
     it "update corresponding user attributes" do
       patch :update_profile, id: sameer.id, profile: {first_name: "gecko"}, format: :js
       sameer.reload
       expect(sameer.first_name).to eq "gecko"
     end
   end
  end




  # describe "GET new live session" do

  #   context "not logged in" do

  #     it "can not access new live session page" do
  #       get :new_live_session, id: sameer.id 
  #       expect(response).to redirect_to root_path
  #     end
  #   end

  #   context "logged in as expert" do
  #     before :each do 
  #       sign_in sameer
  #     end

  #     it "access new live session page" do
  #       get :new_live_session, id: sameer.id, format: :js
  #       expect(response).to be_success 
  #     end

  #     it "can not access other expert's new live session page" do
  #       get :new_live_session, id: alex.id, format: :js
  #       expect(response).not_to be_success 
  #     end

  #     it "assigns new live session" do
  #       get :new_live_session, id: sameer.id, format: :js
  #       expect(assigns[:live_session]).to be_a_new(Session)
  #     end
  #   end
  #   
  # end


end
