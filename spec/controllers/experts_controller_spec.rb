require 'spec_helper'

describe ExpertsController do
  helper_objects


  context "not logged in" do
    it "can not access all dashboard page" do
      expect{ get :dashboard, id: sameer.id }.to raise_error(CanCan::AccessDenied)
      expect{ get :new_post_content, id: sameer.id }.to raise_error(CanCan::AccessDenied)
      expect{ get :new_session, id: sameer.id}.to raise_error(CanCan::AccessDenied)
    end
  end
  

  context "logged in as member" do
    before :each do
      sign_in peter
    end
    it "can not access all dashboard page" do
      expect{ get :dashboard, id: sameer.id }.to raise_error(CanCan::AccessDenied)
      expect{ get :new_post_content, id: sameer.id }.to raise_error(CanCan::AccessDenied)
      expect{ get :new_session, id: sameer.id}.to raise_error(CanCan::AccessDenied)
    end
  end


  describe "expert can access all his dashboard functionalities" do
    before :each do
      sign_in sameer
    end
    it "can access his own dashboard main page" do
      get :dashboard, id: sameer.id
      expect(response).to render_template "dashboard"
    end
    it "can access new session page" do
      get :new_session, id: sameer.id
      expect(response).to render_template "new_session"
    end
  end
  

  describe "expert can not access other expert's dashboard" do
    before :each do
      sign_in sameer
    end
    it "can not access other expert's dashboard main page" do
      expect{ get :dashboard, id: alex.id }.to raise_error(CanCan::AccessDenied)
    end
    it "can not access other expect's new session page" do
      expect{ get :new_session, id: alex.id }.to raise_error(CanCan::AccessDenied)
    end
  end
  

  describe "GET dashboard" do
    context "logged in as expert" do
      before :each do
        sign_in sameer
      end
      it "assigns sessions" do
        get :dashboard, id: sameer.id
        expect(assigns[:sessions]).to eq sameer.sessions
      end
    end
  end



  describe "GET new session" do
    context "logged in as expert" do
      before :each do 
        sign_in sameer
      end
      it "assigns new session" do
        get :new_session, id: sameer.id
        expect(assigns[:live_session]).to be_new_record
      end
    end
  end

end
