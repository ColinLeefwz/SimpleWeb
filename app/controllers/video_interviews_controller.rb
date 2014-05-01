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
      format.html {
        render "dashboard/edit_content", locals: { form_partial: "video_interviews/form" }
      }
    end
  end

  def update
    @video_interview.update_attributes(video_interview_params)

    respond_to do |format|
      format.js { render "dashboard/save_content" }
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
