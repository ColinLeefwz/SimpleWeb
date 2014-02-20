require 'spec_helper'

describe UsersController do
  helper_objects

  describe "GET relationship" do

    context "logged in member" do
      before :each do
        sign_in peter
      end

      it "can follow the expert" do
        get :relationship, the_followed: sameer.id, format: :js
        expect(sameer.followers).to include peter
      end

      it "can unfollow the expert if already follow the expert" do
        sameer.followers << peter
        get :relationship, the_followed: sameer.id, format: :js
        expect(sameer.reload.followers.map &:id).not_to include peter.id
      end
    end
  end

  # todo: gecko: we can write a shared_example like behave like subscribable
  # describe "GET subscribe_session" do
  #   context "logged in member" do
  #     before :each do
  #       sign_in jevan
  #     end

  #     it "can subscribe session" do 
  #       get :subscribe_session, session_id: session_intro.id, format: :js
  #       expect(jevan.subscribed_sessions).to include session_intro
  #     end

  #     it "can unsubscribe session if already subscribe the session" do
  #       session_intro.subscribers << jevan
  #       get :subscribe_session, session_id: session_intro.id, format: :js
  #       expect(session_intro.reload.subscribers).not_to include jevan
  #     end
  #   end

  # end

end
