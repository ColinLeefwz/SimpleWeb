class VideoInterviewsController < ApplicationController
  def index
  end

  def show
		@video_interview = VideoInterview.find(params[:id])
  end
end
