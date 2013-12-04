class ResourcesController < ApplicationController
  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(resource_params)
    if @resource.save
      paperclip_file_path = "resources/attached_files/#{@resource.id}/original/#{params[:resource][:attached_file_file_name]}"
      raw_source = params[:resource][:attached_file_file_path]

      Resource.copy_and_delete paperclip_file_path, raw_source
    end
  end


  private
  def resource_params
    params.require(:resource).permit(:expert_id, :direct_upload_url, :attached_file_file_path, :attached_file_content_type, :attached_file_file_size, :attached_file_file_name)
  end
end
