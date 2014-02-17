require 'spec_helper'

describe User do
  helper_objects

  describe ".has_subscribed?" do
    it "returns false if not subscribe the course" do
      expect(jevan.has_subscribed? first_course).to be_false
    end

    it "returns true if already subscribe the session" do
      jevan.subscribe first_course
      expect(jevan.has_subscribed? first_course).to be_true
    end
  end

  describe ".subscribe" do
    it "adds the course to user's subscribed_courses" do
      jevan.subscribe first_course
      expect(jevan.subscribed_courses).to include first_course
    end

    it "add video interview to user's subscribed_video_interviews" do
      gecko.subscribe video_interview
      expect(gecko.subscribed_video_interviews).to include video_interview
    end
  end

  describe ".unsubscribe" do
    it "deletes the session from user's subscribed_sessions" do
      article = create(:article, title: "subscribe me")
      Subscription.create(subscriber_id: gecko.id, subscribable: article)
      gecko.unsubscribe article
      expect(gecko.subscribed_sessions).not_to include article
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

    it "just unfollows the one" do
      allen.followed_users << [peter, sameer, alex]
      allen.unfollow peter
      expect(allen.reload.followed_users).to include alex
      expect(allen.reload.followed_users).to include sameer
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
