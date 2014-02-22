class SectionsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_section, only: [:edit, :update]

  def edit
  end

  def update
    @section.update_attributes(section_params)
    redirect_to preview_course_path(@section.course)
  end


  private
  def set_section
    @section = Section.find params[:id]
  end
  def section_params
    params.require(:section).permit(:id, :title, :description, :duration, :free_preview, 
                                    video_attributes: [:id, :cover, :SD_file_name, :SD_content_type, :SD_file_size, :SD_temp_path,  :HD_file_name, :HD_content_type, :HD_file_size, :HD_temp_path])
  end
end
