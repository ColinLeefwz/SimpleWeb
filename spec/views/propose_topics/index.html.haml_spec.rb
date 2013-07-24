require 'spec_helper'

describe "propose_topics/index" do
  before(:each) do
    assign(:propose_topics, [
      stub_model(ProposeTopic,
        :Name => "Name",
        :Location => "Location",
        :Email => "Email",
        :Topic => "MyText"
      ),
      stub_model(ProposeTopic,
        :Name => "Name",
        :Location => "Location",
        :Email => "Email",
        :Topic => "MyText"
      )
    ])
  end

  it "renders a list of propose_topics" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
