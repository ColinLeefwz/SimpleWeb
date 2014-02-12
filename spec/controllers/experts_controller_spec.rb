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
end
