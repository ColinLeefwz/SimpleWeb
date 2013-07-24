require 'spec_helper'

describe "propose_topics/show" do
  before(:each) do
    @propose_topic = assign(:propose_topic, stub_model(ProposeTopic,
      :Name => "Name",
      :Location => "Location",
      :Email => "Email",
      :Topic => "MyText"
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
