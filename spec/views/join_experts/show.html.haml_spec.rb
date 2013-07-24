require 'spec_helper'

describe "join_experts/show" do
  before(:each) do
    @join_expert = assign(:join_expert, stub_model(JoinExpert,
      :Name => "Name",
      :Location => "Location",
      :Email => "Email",
      :Expertise => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Location/)
    rendered.should match(/Email/)
    rendered.should match(/MyText/)
  end
end
