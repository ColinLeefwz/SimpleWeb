require 'spec_helper'

describe CoursesController do
  helper_objects

  describe "GET new" do
    context "not logged in" do
      it "can not access course creation page" do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    context "logged in as admin" do
      before :each do
        sign_in admin
      end

      it "can access course creation page" do
        get :new
        expect(assigns[:course]).to be_new_record
      end
    end
  end

  # describe "POST create" do
  #   context "not logged in"

  #   context "logged in as admin" do
  #     before :each do
  #       sign_in admin
  #     end

  #     it "create a new course using form params" do
  #       post :create, course_params
  #       # expect{ post :create, course_params }.to be_successful
  #     end
  #   end
  # end
end
