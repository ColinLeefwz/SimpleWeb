class WelcomeController < ApplicationController

  def index
    @items = Landingitem.all_index_items
    # video_interviews = VideoInterview.includes(:expert)
    # annoucements = Announcement.includes(:expert)
    # articles = Article.includes(:expert).where(draft: false)
    # collection = video_interviews + annoucements + articles
    # @items = collection.sort{|x, y| y.updated_at <=> x.updated_at}
    @show_category = true
  end

  def load_more
    logger.info "welcome load more"
    respond_to do |format|
      format.js { render "load_more" }
    end
  end

end
