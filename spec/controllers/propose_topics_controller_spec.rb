require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ProposeTopicsController do

  # This should return the minimal set of attributes required to create a valid
  # ProposeTopic. As you add validations to ProposeTopic, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "Name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProposeTopicsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all propose_topics as @propose_topics" do
      propose_topic = ProposeTopic.create! valid_attributes
      get :index, {}, valid_session
      assigns(:propose_topics).should eq([propose_topic])
    end
  end

  describe "GET show" do
    it "assigns the requested propose_topic as @propose_topic" do
      propose_topic = ProposeTopic.create! valid_attributes
      get :show, {:id => propose_topic.to_param}, valid_session
      assigns(:propose_topic).should eq(propose_topic)
    end
  end

  describe "GET new" do
    it "assigns a new propose_topic as @propose_topic" do
      get :new, {}, valid_session
      assigns(:propose_topic).should be_a_new(ProposeTopic)
    end
  end

  describe "GET edit" do
    it "assigns the requested propose_topic as @propose_topic" do
      propose_topic = ProposeTopic.create! valid_attributes
      get :edit, {:id => propose_topic.to_param}, valid_session
      assigns(:propose_topic).should eq(propose_topic)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ProposeTopic" do
        expect {
          post :create, {:propose_topic => valid_attributes}, valid_session
        }.to change(ProposeTopic, :count).by(1)
      end

      it "assigns a newly created propose_topic as @propose_topic" do
        post :create, {:propose_topic => valid_attributes}, valid_session
        assigns(:propose_topic).should be_a(ProposeTopic)
        assigns(:propose_topic).should be_persisted
      end

      it "redirects to the created propose_topic" do
        post :create, {:propose_topic => valid_attributes}, valid_session
        response.should redirect_to(ProposeTopic.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved propose_topic as @propose_topic" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProposeTopic.any_instance.stub(:save).and_return(false)
        post :create, {:propose_topic => { "Name" => "invalid value" }}, valid_session
        assigns(:propose_topic).should be_a_new(ProposeTopic)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ProposeTopic.any_instance.stub(:save).and_return(false)
        post :create, {:propose_topic => { "Name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested propose_topic" do
        propose_topic = ProposeTopic.create! valid_attributes
        # Assuming there are no other propose_topics in the database, this
        # specifies that the ProposeTopic created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ProposeTopic.any_instance.should_receive(:update).with({ "Name" => "MyString" })
        put :update, {:id => propose_topic.to_param, :propose_topic => { "Name" => "MyString" }}, valid_session
      end

      it "assigns the requested propose_topic as @propose_topic" do
        propose_topic = ProposeTopic.create! valid_attributes
        put :update, {:id => propose_topic.to_param, :propose_topic => valid_attributes}, valid_session
        assigns(:propose_topic).should eq(propose_topic)
      end

      it "redirects to the propose_topic" do
        propose_topic = ProposeTopic.create! valid_attributes
        put :update, {:id => propose_topic.to_param, :propose_topic => valid_attributes}, valid_session
        response.should redirect_to(propose_topic)
      end
    end

    describe "with invalid params" do
      it "assigns the propose_topic as @propose_topic" do
        propose_topic = ProposeTopic.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ProposeTopic.any_instance.stub(:save).and_return(false)
        put :update, {:id => propose_topic.to_param, :propose_topic => { "Name" => "invalid value" }}, valid_session
        assigns(:propose_topic).should eq(propose_topic)
      end

      it "re-renders the 'edit' template" do
        propose_topic = ProposeTopic.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ProposeTopic.any_instance.stub(:save).and_return(false)
        put :update, {:id => propose_topic.to_param, :propose_topic => { "Name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested propose_topic" do
      propose_topic = ProposeTopic.create! valid_attributes
      expect {
        delete :destroy, {:id => propose_topic.to_param}, valid_session
      }.to change(ProposeTopic, :count).by(-1)
    end

    it "redirects to the propose_topics list" do
      propose_topic = ProposeTopic.create! valid_attributes
      delete :destroy, {:id => propose_topic.to_param}, valid_session
      response.should redirect_to(propose_topics_url)
    end
  end

end
