class ResourcesController < ApplicationController
  load_and_authorize_resource
  def new
    @resource = Resource.new
  end

  def create
    @resource = Resource.new(resource_params)
    @resource.save
  end


  private
  def resource_params
    params.require(:resource).permit(:expert_id, :direct_upload_url, :attached_file_file_path, :attached_file_content_type, :attached_file_file_size, :attached_file_file_name)
  end
end
