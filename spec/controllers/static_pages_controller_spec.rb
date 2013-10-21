require 'spec_helper'

describe StaticPagesController do
  helper_objects

  describe "GET static" do
    before :each do
      [page_faq, page_terms, page_about_us]
    end

    it "shows the corresponding static page" do
      get :static, page: "about_us"
      expect(assigns[:static_page]).to eq page_about_us
    end
  end

end
