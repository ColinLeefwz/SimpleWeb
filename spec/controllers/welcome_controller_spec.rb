require 'spec_helper'

describe WelcomeController do
  helper_objects

  describe 'GET index' do
    it "assigns sessions" do
      get :index
      expect(assigns[:sessions].count).to eq Session.all.count
    end
  end
end
