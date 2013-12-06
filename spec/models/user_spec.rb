require 'spec_helper'

describe User do
	helper_objects

  describe ".has_subscribed?" do
    it "returns false if not subscribe the session" do
      expect(jevan.has_subscribed? session_intro).to be_false
    end

    it "returns true if already subscribe the session" do
      jevan.subscribed_sessions << session_intro
      expect(jevan.has_subscribed? session_intro).to be_true
    end
  end

  describe ".subscribe" do
    it "adds the session to user's subscribed_sessions" do
      jevan.subscribe session_intro
      expect(jevan.reload.subscribed_sessions).to include session_intro
    end
  end

  describe ".unsubscribe" do
    it "deletes the session from user's subscribed_sessions" do
      jevan.subscribe session_intro
      jevan.unsubscribe session_intro
      expect(jevan.reload.subscribed_sessions).not_to include session_intro
    end
  end

	describe ".enroll_session" do
		it "adds a session to user's enrolled_sessions" do
			allen.enroll_session session_find
			allen.enroll_session session_map
			expect(allen.enrolled_sessions.count).to eq 2
		end
	end

	describe ".follow?" do
		it "returns true if already followed me" do
			peter.followers << allen
			expect(allen.follow? peter).to be_true
		end

		it "returns false if not followed me" do
			expect(allen.follow? peter).to be_false
		end
	end

	describe ".follow" do
		it "follows the followed one" do
			peter.follow allen
			expect(peter.reload.followed_users).to include allen
		end
	end

	describe ".unfollow" do
		it "un-follows the followed one" do
			peter.followers << allen
			allen.unfollow peter
			expect(peter.reload.followers).not_to include allen
		end
	end

  describe ".build_refer_message" do 
    context "member can build an email message" do
      it "creates a new email message" do
        message = peter.build_refer_message("member")
        expect(message.user_id).to eq peter.id
      end
    end

    context "expert can build an email message" do
      it "creates a new email message" do
        message = sameer.build_refer_message("member")
        expect(message).to be_new_record
      end
    end


  end
end
