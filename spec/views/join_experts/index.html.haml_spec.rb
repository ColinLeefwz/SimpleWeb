require 'spec_helper'

describe "join_experts/index" do
  before(:each) do
    assign(:join_experts, [
      stub_model(JoinExpert,
        :Name => "Name",
        :Location => "Location",
        :Email => "Email",
        :Expertise => "MyText"
      ),
      stub_model(JoinExpert,
        :Name => "Name",
        :Location => "Location",
        :Email => "Email",
        :Expertise => "MyText"
      )
    ])
  end

  it "renders a list of join_experts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
