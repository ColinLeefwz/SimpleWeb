class SectionsController < ApplicationController
  before_filter :set_section, only: [:edit, :update]

  def edit
    @section.resources.destroy_all
  end

  def update
    @section.update(section_params)
    redirect_to course_preview_path(@section.chapter.course)
  end


  private
  def set_section
    @section = Section.find params[:id]
  end
  def section_params
    params.require(:section).permit(:title, :description, resources_attributes: [:video_definition, :direct_upload_url, :attached_file_file_name, :attached_file_file_size, :attached_file_content_type, :attached_file_file_path])
  end
end
