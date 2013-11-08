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
    FileUtils.mv( params[:file].tempfile.path, "public"+ "/dface#{@version._id}.apk")
    `scp /mnt/lianlian/public/dface#{@version._id}.apk web1:/mnt/lianlian/public/`
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
    redirect_to :action => :show, :id => @version.id
  end

  def delete
    version = Version.find(params[:id])
    version.delete
    $redis.set("android_version", Version.last.id)
    render :json => ''
  end
    

end