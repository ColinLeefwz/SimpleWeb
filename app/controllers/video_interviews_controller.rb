class VideoInterviewsController < ApplicationController
  before_filter :set_video_interview, only: [:show, :edit, :update]

  def index
  end

  def show
  end

  def edit
    @from = 'video_interviews/form'
    respond_to do |format|
      format.js{render 'experts/update'}
    end
  end

  def update
    @video_interview.update_attributes(video_interview_params)

    @items = current_user.contents
    respond_to do |format|
      format.js{
        render partial: 'shared/cards', locals: { items: @items }
      }
    end
  end

  private
  def set_video_interview
    @video_interview = VideoInterview.find params[:id]
  end

  def video_interview_params
    params.require(:video_interview).permit(:title, {category_ids: []}, :description, :cover)
  end
end
