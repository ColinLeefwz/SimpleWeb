require 'spec_helper'

describe "propose_topics/edit" do
  before(:each) do
    @propose_topic = assign(:propose_topic, stub_model(ProposeTopic,
      :Name => "MyString",
      :Location => "MyString",
      :Email => "MyString",
      :Topic => "MyText"
    ))
  end

  it "renders the edit propose_topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", propose_topic_path(@propose_topic), "post" do
      assert_select "input#propose_topic_Name[name=?]", "propose_topic[Name]"
      assert_select "input#propose_topic_Location[name=?]", "propose_topic[Location]"
      assert_select "input#propose_topic_Email[name=?]", "propose_topic[Email]"
      assert_select "textarea#propose_topic_Topic[name=?]", "propose_topic[Topic]"
    end
  end
end
