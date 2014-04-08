class WelcomeController < ApplicationController

  def index
    # Peter at 2014-04-07: comment them, after we fix the overlap bug
    # cookies[:landing_batch_point] = 0
    # cookies[:no_more_load] = false
    # @items = Landingitem.all_index_items(0)
    # increase_cookie

    ## Peter at 2014-03-20: keep them for a while to make a comparation
    video_interviews = VideoInterview.includes(:expert)
    annoucements = Announcement.includes(:expert)
    articles = Article.includes(:expert).where(draft: false)
    courses = Course.all_without_staff
    collection = video_interviews + annoucements + articles + courses
    @items = collection.sort{|x, y| y.updated_at <=> x.updated_at}
    @show_category = true
  end

  # Peter at 2014-04-07: not used when we hide the load_more function
  # def load_more
  #   point = cookies[:landing_batch_point].to_i
  #   @items = Landingitem.all_index_items(point)
  #   respond_to do |format|
  #     if Landingitem.next(point + 1)
  #       cookies[:no_more_load] = false
  #     else
  #       cookies[:no_more_load] = true
  #     end
  #     increase_cookie
  #     format.js { render "load_more" }
  #   end
  # end

  # private
  # def increase_cookie
  #   new_val = cookies[:landing_batch_point].to_i + 1
  #   cookies[:landing_batch_point] = new_val
  # end

end
