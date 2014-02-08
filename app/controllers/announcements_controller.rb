class AnnouncementsController < ApplicationController
  def index
  end

  def show
    @announcement = Announcement.find(params[:id])
  end
end
