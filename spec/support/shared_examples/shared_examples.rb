shared_examples "guest" do
  include_examples "can not access the dashboard page" 
  include_examples "can not assign sessions" 
end

shared_examples "member" do
  include_examples "can not access the dashboard page" 
  include_examples "can not assign sessions" 
end

shared_examples "can not access the dashboard page" do
  get :dashboard, id: sameer.id
  expect(response).to redirect_to root_path
end

shared_examples "can not assign sessions" do
  get :dashboard, id: sameer.id
  expect(assigns[:sessions]).to be_nil
end
