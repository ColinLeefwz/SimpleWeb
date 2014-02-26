require 'spec_helper'

describe MembersController do
  helper_objects

  before :each do
    Expert.delete_all
  end

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
        # todo: gecko: test follow recommendation (no user followed)
        # get :experts, id: peter.id, format: :js
        # expect(assigns[:followed_experts].to_a).to eq peter.followed_users.to_a
        peter.follow sameer
        peter.follow alex
        get :experts, id: peter.id, format: :js
        expect(assigns[:followed_experts]).to include sameer
        expect(assigns[:followed_experts]).to include alex
      end

      it "can access to followed experts page" do
        get :experts, id: peter.id, format: :js
        expect(response).to be_success
      end
    end
  end

  describe "GET contents" do
    before :each do 
      sign_in gecko
      staff = create(:expert, id: 2)
    end

    it "assigns the article sessions the member subscribed" do
      gecko.subscribe(article)
      gecko.subscribe(video_interview)
      get :contents, id: gecko.id, format: :js
      expect(assigns[:favorite_contents]).to include video_interview
      expect(assigns[:favorite_contents]).to include article
    end

    it "can access to contents page" do
      get :contents, id: gecko.id, format: :js
      expect(response).to be_success
    end
  end

  describe "GET video_on_demand" do
    before :each do
      staff
    end

    context "current user is an expert" do
      before :each do
        sign_in sameer
      end

      it "can access to contents page" do
        get :video_on_demand, id: sameer.id, format: :js
        expect(response).to be_success
      end

      it "shows Staff's courses for recommendation" do
        courses = create_list(:course, 5, title: "course", experts: [sameer], categories: ["culture"])
        staff_course = create_list(:course, 4, title: "staff course", experts: [staff], categories: ["culture"])
        sign_in sameer
        get :video_on_demand, id: sameer.id, format: :js
        expect(assigns[:subscribed_courses]).to include staff_course[0]
        expect(assigns[:subscribed_courses].count).to eq 3
      end

      it "excludes his own courses for recommendation" do
        Course.delete_all
        courses = create_list(:course, 5, title: "course", experts: [sameer], categories: ["culture"])
        staff_course = create(:course, title: "staff course", experts: [staff], categories: ["culture"])
        get :video_on_demand, id: sameer.id, format: :js
        expect(assigns[:subscribed_courses]).to eq [staff_course]
        expect(assigns[:subscribed_courses].count).to eq 1
      end
    end

    context "current user is a member" do
      before :each do
        sign_in jevan
      end

      it "can access to contents page" do
        get :video_on_demand, id: jevan.id, format: :js
        expect(response).to be_success
      end

      context "no favoriteed courses, show recommendations" do
        it "excludes Staff's courses" do
          staff_course = create(:course, title: "staff course", experts: [staff], categories: ["culture"])
          get :video_on_demand, id: jevan.id, format: :js
          expect(assigns[:subscribed_courses]).not_to include staff_course
        end

        it "excludes my subscribed courses" do
          enrolled_course = create(:course, title: "subscribed course", experts: [sameer], categories: ["culture"])
          jevan.enroll new_course
          get :video_on_demand, id: jevan.id, format: :js
          expect(assigns[:recommendation]).to be_true ## recommendation
          expect(assigns[:subscribed_courses]).not_to include enrolled_course
        end
      end
    end
  end
end
