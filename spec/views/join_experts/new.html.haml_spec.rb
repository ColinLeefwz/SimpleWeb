require 'spec_helper'

describe "join_experts/new" do
  before(:each) do
    assign(:join_expert, stub_model(JoinExpert,
      :Name => "MyString",
      :Location => "MyString",
      :Email => "MyString",
      :Expertise => "MyText"
    ).as_new_record)
  end

  it "renders new join_expert form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", join_experts_path, "post" do
      assert_select "input#join_expert_Name[name=?]", "join_expert[Name]"
      assert_select "input#join_expert_Location[name=?]", "join_expert[Location]"
      assert_select "input#join_expert_Email[name=?]", "join_expert[Email]"
      assert_select "textarea#join_expert_Expertise[name=?]", "join_expert[Expertise]"
    end
  end
end
