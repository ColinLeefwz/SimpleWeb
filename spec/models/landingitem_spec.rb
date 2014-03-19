require 'spec_helper'

describe Landingitem do
  helper_objects

  describe "auto created when create new records" do
    it "created one after creating a new Article" do
      article
      expect(Landingitem.count).to eq 1
      expect(Landingitem.first.expert).to eq sameer
    end

    it "created one after creating a new VideoInterview" do
      video_interview
      expect(Landingitem.count).to eq 1
      expect(Landingitem.first.expert).to eq sameer
    end

    it "created one after creating a new Announcement" do
      announcement
      expect(Landingitem.count).to eq 1
      expect(Landingitem.first.expert).to eq alex
    end

    it "created one after creating a new Announcement" do
      course = create :course, title: "first course", description: "course description", experts: [sameer, alex], categories: ["culture"]
      expect(Landingitem.count).to eq 2
      expect(Landingitem.first.expert).to eq sameer
      expect(Landingitem.first.only_index).to be_false
    end
  end
end
