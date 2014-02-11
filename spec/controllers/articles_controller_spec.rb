require 'spec_helper'

describe ArticlesController do
  helper_objects

  ## The Mandrill Key uploaded to CI
  describe "POST email_friend" do
    context "not logged in user"
    context "logged in user" do
      it "construct the email content" do
        post :email_friend, id: session_intro, email_friend: {"your_name"=>"peter", "your_address"=>"peter@originate.com", "to_name"=>"Tina", "to_address"=>"tina@oc.com", "content"=>"some content"}
        expect(assigns[:email]).not_to be_nil
      end
    end
  end
end
