class AdminVersionsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
    sort = {}
    @versions = paginate3("Version", params[:page], hash, sort)
  end

  def new
    @version = Version.new
  end

  def create
    @version = Version.new(params[:version])
    @version._id = params[:version][:id]
    @version.save
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
    render :json => ''
  end
    

end