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

    it "created one after creating a new Course" do
      course = create :course, title: "first course", description: "course description", experts: [sameer, alex], categories: ["culture"]
      expect(Landingitem.count).to eq 2
      expect(Landingitem.first.expert).to eq sameer
    end

    it "will not add one after create an Staff course" do
      course = create :course, title: "first course", description: "course description", experts: [staff], categories: ["culture"]
      expect(Landingitem.count).to eq 0
    end
  end

  describe "update record in landingitems if update an real content" do
    it "updated landingitem record if update an article" do
      article.update_attributes title: "new title"
      expect(Landingitem.count).to eq 1
      expect(Landingitem.first.updated_at).to eq article.updated_at
    end

    it "updated the draft attributes" do
      User.delete_all
      ar = create(:article, title: "draft one", expert: sameer, categories: ["culture"], draft: true)
      ar.update_attributes draft: false
      expect(Landingitem.last.draft).to be_false
    end

  end

  describe "#all_index_items" do
    it "lists all items shown only in landing page" do
      article
      video_interview
      announcement
      expect(Landingitem.all_index_items(0)).to eq [announcement, video_interview, article]
    end

    it "limits the count to 12" do
      article_list = create_list(:article, 14, title: "article", expert: sameer, categories: ["culture"])
      video_interview_list = create_list(:video_interview, 14, expert: sameer, categories: ["culture"])
      expect(Landingitem.all_index_items(0).count).to eq 12
    end

    it "only shows one if there're two same courses" do
      course = create :course, title: "first course", description: "course description", experts: [sameer, alex], categories: ["culture"]
      expect(Landingitem.all_index_items(0).count).to eq 1
    end
  end

end
