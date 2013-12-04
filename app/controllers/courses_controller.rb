class CoursesController < ApplicationController

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.save
    redirect_to new_course_path
  end

  def show
  end

  private
  def course_params
    params.require(:course).permit(:title, :description, {expert_ids: []})
  end
end
