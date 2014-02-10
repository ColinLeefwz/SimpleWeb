require 'spec_helper'

describe MembersController do
  helper_objects

  describe "GET dashboard" do
  end
   
  describe "GET profile" do 
  end

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

  describe "GET refer_a_friend" do 
    context "logged in member" do
      before :each do
        sign_in jevan
      end

      it "creates a invitation email message" do 
        get :refer_a_friend, id: jevan.id, format: :js 
        expect(assigns[:email_message]).to be_new_record
      end 

      it "can access to firiend invitation page" do 
        get :refer_a_friend, id: jevan.id, format: :js 
        expect(response).to be_success
      end 
    end
  end

	describe "GET experts" do
		context "logged in member" do
			before :each do
				sign_in peter
			end

			it "assigns all the experts the member followed" do
				get :experts, id: peter.id, format: :js
				expect(assigns[:followed_experts]).to eq peter.followed_users
			end

      it "can access to followed experts page" do
        get :experts, id: peter.id, format: :js
        expect(response).to be_success
      end
		end
	end

  describe "GET contents" do
    before :each do 
      sign_in jevan
    end

    it "assigns the article sessions the member subscribed" do
      jevan.subscribe(video_interview)
      jevan.subscribe(session_communication)
      get :contents, id: jevan.id, format: :js
      expect(assigns[:favorite_contents]).to include video_interview
      expect(assigns[:favorite_contents]).to include session_communication

    end

    it "can access to contents page" do
      get :contents, id: jevan.id, format: :js
      expect(response).to be_success
    end
  end

  describe "GET video_on_demand" do
    before :each do 
      sign_in jevan
    end

    it "can access to contents page" do
      get :video_on_demand, id: jevan.id, format: :js
      expect(response).to be_success
    end
  end
end
