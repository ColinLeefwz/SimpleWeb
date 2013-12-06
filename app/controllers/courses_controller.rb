class CoursesController < ApplicationController

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.save
    redirect_to course_preview_path(@course)
  end

  def preview
    @course = Course.find params[:id]
  end

  private


  def course_params
    params.require(:course).permit(:title, :description, {expert_ids: []}, chapters_attributes: [:title, :description, :order, :_destroy, sections_attributes: [:title, :description, :order, :_destroy] ])
  end
end
