require 'spec_helper'

describe ExpertsController do
  helper_objects

  describe "GET dashboard" do
    context "not logged in" do
      it "can not access the dashboard page" do
        expect{ get :dashboard, id: sameer.id }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "logged in as member" do
      before :each do
        sign_in peter
      end

      it "can not access the dashboard page" do
        expect{ get :dashboard, id: sameer.id }.to raise_error(CanCan::AccessDenied)
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
        expect(assigns[:sessions]).to eq sameer.sessions
      end

      it "can not access other's dashboard page" do
        expect{ get :dashboard, id: alex.id }.to raise_error(CanCan::AccessDenied)
      end
    end

  end

end
