require 'spec_helper'

describe MembersController do
  helper_objects

  describe "GET edit profile" do
    context "not logged in" do
      it "can't access edit profile page" do
        get :edit_profile, id: gecko.id, format: :js
        expect(response).to redirect_to root_path
      end
    end

    context "logged in as member" do 
      before :each do
        sign_in gecko
      end

      it "can't access other member's edit profile page" do
        get :edit_profile, id: peter.id, format: :js
        expect(response).to redirect_to root_path
      end
      it "can access his own edit profile page" do
        get :edit_profile, id: gecko.id, format: :js
        expect(assigns[:profile]).to eq gecko.profile
      end
    end
  end

  describe "PATCH update profile" do
    context "logged in as member" do
      before :each do
        gecko_profile
        sign_in gecko
      end

      it "update corresponding user profile" do
        patch :update_profile, id: gecko.id, profile: attributes_for(:profile, title: "new title"), format: :js
        expect(gecko.profile.title).to eq "new title"
      end

      it "update corresponding user attributes" do
        patch :update_profile, id: gecko.id, profile: {first_name: "new_first_name"}, format: :js
        gecko.reload
        expect(gecko.first_name).to eq "new_first_name"
      end
    end
  end
end
