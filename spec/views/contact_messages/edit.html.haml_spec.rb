require 'spec_helper'

describe "contact_messages/edit" do
  before(:each) do
    @contact_message = assign(:contact_message, stub_model(ContactMessage,
      :name => "MyString",
      :email => "",
      :message => "MyText"
    ))
  end

  it "renders the edit contact_message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", contact_message_path(@contact_message), "post" do
      assert_select "input#contact_message_name[name=?]", "contact_message[name]"
      assert_select "input#contact_message_email[name=?]", "contact_message[email]"
      assert_select "textarea#contact_message_message[name=?]", "contact_message[message]"
    end
  end
end
