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
		@course.build_intro_video
	end

	def create
		@course = Course.new(course_params)
		@course.save
		redirect_to preview_course_path(@course)
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
		params.require(:course).permit(:title, :description, :cover, {categories:[]}, {expert_ids: []}, chapters_attributes: [:title, :description, :order, :_destroy, sections_attributes: [:title, :description, :order, :_destroy] ], intro_video_attributes: [:attached_video_hd_file_name, :attached_video_hd_content_type, :attached_video_hd_file_size, :attached_video_sd_file_name, :attached_video_sd_content_type, :attached_video_sd_file_size, :sd_url, :hd_url])
	end
end
