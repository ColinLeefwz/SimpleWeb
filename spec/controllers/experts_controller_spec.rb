require 'spec_helper'

describe ExpertsController do
  describe 'GET index' do
  	it 'assigns @experts' do
  	  experts = Expert.all
  	  get :index
      expect(assigns[:experts]).to eq(experts)
  	end

  	it 'render the index page' do
      get :index
  	  expect(response).to render_template('index')
  	end
  end

  describe 'GET show' do
  	it 'render the show page' do
  	  Expert.delete_all
  	  jevan = Expert.create(name: 'jevan')
      get :show, id: jevan.id
  	  expect(response).to render_template('show')
  	end
  end

  describe 'GET new' do
  	it 'assigns @expert' do
  	  get :new 
  	  assigns[:expert].should be_new_record
    end
  end 

  describe 'POST create' do
  	it 'creates a expert' do
  	  Expert.delete_all
      post :create, expert: { name: 'jevan' }
      Expert.count.should eq 1
      Expert.first.name.should eq 'jevan'
    end
  end
end
