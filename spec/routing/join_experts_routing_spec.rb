require "spec_helper"

describe JoinExpertsController do
  describe "routing" do

    it "routes to #index" do
      get("/join_experts").should route_to("join_experts#index")
    end

    it "routes to #new" do
      get("/join_experts/new").should route_to("join_experts#new")
    end

    it "routes to #show" do
      get("/join_experts/1").should route_to("join_experts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/join_experts/1/edit").should route_to("join_experts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/join_experts").should route_to("join_experts#create")
    end

    it "routes to #update" do
      put("/join_experts/1").should route_to("join_experts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/join_experts/1").should route_to("join_experts#destroy", :id => "1")
    end

  end
end
