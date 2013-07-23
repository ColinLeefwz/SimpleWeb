require 'spec_helper'

describe WelcomeController do
  context 'GET index' do
  	it "assigns @prodygia_picks" do
  		prodia = Session.where(status: "Prodygia Picks")
  		get :index
  		expect(assigns[:prodygia_picks]).to eq(prodia)
  	end

  	it "assigns @scheduled" do
  		scheduled = Session.where(status: "Scheduled")
  		get :index
  		expect(assigns[:scheduled]).to eq(scheduled)
  	end

  	it "assigns @upcoming" do
  		upcoming = Session.where(status: "Upcoming")
  		get :index
  		expect(assigns(:upcoming)).to eq(upcoming)
  	end

  	it "redirect to 'index' page" do
  		get :index
  		expect(response).to render_template("index")
  	end
  end
end
