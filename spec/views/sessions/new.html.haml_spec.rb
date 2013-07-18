require 'spec_helper'

describe "sessions/new" do
  before(:each) do
    assign(:session, stub_model(Session,
      :title => "MyString",
      :expert_id => nil,
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new session form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", sessions_path, "post" do
      assert_select "input#session_title[name=?]", "session[title]"
      assert_select "input#session_expert_id[name=?]", "session[expert_id]"
      assert_select "textarea#session_description[name=?]", "session[description]"
    end
  end
end
