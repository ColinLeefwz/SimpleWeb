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
    redirect_to course_preview_path(@course)
  end

  def preview
  end

  private
  def set_course
    @course = Course.find params[:id]
  end

  def course_params
    params.require(:course).permit(:title, :description, :cover, {categories:[]}, {expert_ids: []}, chapters_attributes: [:title, :description, :order, :_destroy, sections_attributes: [:title, :description, :order, :_destroy] ])
  end
end
