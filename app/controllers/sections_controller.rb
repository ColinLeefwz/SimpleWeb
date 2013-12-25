class SectionsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_section, only: [:edit, :update]

  def edit
    @hd_resource = @section.resources.where(video_definition: "HD").first_or_create
    @sd_resource = @section.resources.where(video_definition: "SD").first_or_create
  end

  def update
    @section.update(section_params)
    redirect_to preview_course_path(@section.chapter.course)
  end


  private
  def set_section
    @section = Section.find params[:id]
  end
  def section_params
    params.require(:section).permit(:title, :description, resources_attributes: [:video_definition, :direct_upload_url, :attached_file_file_name, :attached_file_file_size, :attached_file_content_type, :attached_file_file_path])
  end
end
