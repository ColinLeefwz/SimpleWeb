require "spec_helper"

describe ProposeTopicsController do
  describe "routing" do

    it "routes to #index" do
      get("/propose_topics").should route_to("propose_topics#index")
    end

    it "routes to #new" do
      get("/propose_topics/new").should route_to("propose_topics#new")
    end

    it "routes to #show" do
      get("/propose_topics/1").should route_to("propose_topics#show", :id => "1")
    end

    it "routes to #edit" do
      get("/propose_topics/1/edit").should route_to("propose_topics#edit", :id => "1")
    end

    it "routes to #create" do
      post("/propose_topics").should route_to("propose_topics#create")
    end

    it "routes to #update" do
      put("/propose_topics/1").should route_to("propose_topics#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/propose_topics/1").should route_to("propose_topics#destroy", :id => "1")
    end

  end
end
