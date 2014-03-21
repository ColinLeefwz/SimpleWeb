class WelcomeController < ApplicationController

  def index
    cookies[:landing_batch_point] = 0
    @items = Landingitem.all_index_items(0)
    increase_cookie

    ## Peter at 2014-03-20: keep them for a while to make a comparation
    # video_interviews = VideoInterview.includes(:expert)
    # annoucements = Announcement.includes(:expert)
    # articles = Article.includes(:expert).where(draft: false)
    # collection = video_interviews + annoucements + articles
    # @items = collection.sort{|x, y| y.updated_at <=> x.updated_at}
    @show_category = true
  end

  def load_more
    point = cookies[:landing_batch_point].to_i
    @items = Landingitem.all_index_items(point)
    respond_to do |format|
      increase_cookie
      format.js { render "load_more" }
    end
  end

  private
  def increase_cookie
    new_val = cookies[:landing_batch_point].to_i + 1
    cookies[:landing_batch_point] = new_val
  end

end
