require 'spec_helper'

describe LandingitemQuery do
  helper_objects

  describe "#all_items" do
    it "lists all items, including Staff's" do
      [article, video_interview, announcement, course_staff, first_course]
      expect(LandingitemQuery.new.all_items).to match_array([article, video_interview, announcement, course_staff, first_course])
    end
  end

  describe "#all_without_staff" do
    it "lists all items without Staff's courses" do
      [article, video_interview, announcement, course_staff, first_course]
      expect(LandingitemQuery.new.all_without_staff).to match_array([article, video_interview, announcement, first_course])
    end
  end

  describe "private #get_all_raw_data" do
    it "gets all raw Landingitem data" do
      [article, video_interview, announcement, course_staff, first_course]
      expect(LandingitemQuery.new.send(:get_all_raw_data).count).to eq 5
    end

    context "order for items" do
      before :each do
        video_interview.update_landing_order(1)
        article.update_landing_order(2)
        announcement.update_landing_order(3)
      end

      it "orders the items by attribute 'num'" do
        expect(LandingitemQuery.new.send(:get_all_raw_data).map(&:fetch_object)).to eq [video_interview, article, announcement]
      end

      it "puts un-ordered item to the last" do
        new_article = create(:article, expert: sameer, categories: [culture])
        expect(LandingitemQuery.new.send(:get_all_raw_data).map(&:fetch_object)).to eq [video_interview, article, announcement, new_article]
      end
    end
  end
end
