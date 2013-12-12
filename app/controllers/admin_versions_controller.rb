class AdminVersionsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {_id: -1}
    @versions = paginate3("Version", params[:page], hash, sort)
  end

  def new
    @version = Version.new
  end

  def create
    @version = Version.new(params[:version])
    @version._id = params[:version][:id]
    @version.save!
   `/mnt/Oss/oss2/osscmd put #{params[:file].tempfile.path} oss://dface/dface#{@version._id}.apk --content-type=application/octet-stream`
    $redis.set("android_version", @version._id)
    redirect_to :action => :show, :id => @version.id
  end

  def show
    @version = Version.find_primary(params[:id])
  end

  def edit
    @version = Version.find_by_id(params[:id])
  end

  def update
    @version = Version.find(params[:id])
    @version.update_attributes(params[:version])
    $redis.set("android_version", @version._id)
    redirect_to :action => :show, :id => @version.id
  end

  def delete
    version = Version.find(params[:id])
    version.delete
    $redis.set("android_version", Version.last.id)
    render :json => ''
  end

  def upload_test
    if request.post?
     path = "public/a/" + params[:file].original_filename
     File.delete(path) if File.exists?(path)
     FileUtils.mv(params[:file].tempfile.path, path)
     render :text => '成功'
    end

  end

    

end