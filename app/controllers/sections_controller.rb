class SectionsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_section, only: [:edit, :update]

  def edit
    @hd_resource = @section.resources.find_by(video_definition: "HD") || Resource.new(video_definition: "HD")
    @sd_resource = @section.resources.find_by(video_definition: "SD") || Resource.new(video_definition: "SD")
  end

  def update
    @section.update_attributes(section_params)
    redirect_to preview_course_path(@section.chapter.course)
  end


  private
  def set_section
    @section = Section.find params[:id]
  end
  def section_params
    params.require(:section).permit(:title, :description, :duration, :free_preview, resources_attributes: [:video_definition, :direct_upload_url, :attached_file_file_name, :attached_file_file_size, :attached_file_content_type, :attached_file_file_path])
  end
end
