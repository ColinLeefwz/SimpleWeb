class CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :set_course, only: [:show, :preview]

  def index
    @courses = Course.all
  end

  def show
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.save
    redirect_to preview_course_path(@course)
  end

  def edit
  end

  def update
    if @course.update_attributes course_params
      redirect_to course_path(@course), flash: {success: "Update Successfully"}
    else
      redirect_to course_path(@course), flash: {error: "Failed to Update"}
    end

  end

  def preview
  end

  def enroll
    render "courses/enroll", locals: {item: @course}
  end

  private
  def set_course
    @course = Course.find params[:id]
  end

  def course_params
    params.require(:course).permit(:title, :description, :cover, {categories:[]}, {expert_ids: []}, chapters_attributes: [:id, :title, :description, :order, :_destroy, sections_attributes: [:id, :title, :description, :order, :_destroy] ])
  end
end
