require 'spec_helper'

describe ExpertsController do
  context 'GET index' do
  	it 'assigns @experts' do
  	  experts = Expert.all
  	  get :index
      expect(assigns[:experts]).to eq(experts)
  	end

  	it 'render the index page' do
      get :index
  	  expect(response).to render_template("index")
  	end
  end

  context 'GET show' do
  	it 'render the show page' do
      get :show, id: 5
  	  expect(response).to render_template("show")
  	end
  end

  context 'GET new' do
  	it 'assigns @expert' do
  	  get :new 
  	  assigns[:expert].should be_new_record
    end
  end 

  context 'POST create' do
  	it 'creates a expert' do
  	  Expert.delete_all
  	  # expect{post :create, expert: { name: 'jevan' }}.to change{Expert.count}.by(1)
      post :create, expert: { name: 'jevan' }
      Expert.count.should eq 1
      Expert.first.name.should eq 'jevan'
    end
  end
end
