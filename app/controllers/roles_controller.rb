class RolesController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  def initialize
    @menu_tag_id = 9
  end
  
  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.paginate(:conditions => genCondition, :joins => genJoins, :order => genOrder, :page => params[:page], :per_page =>20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        flash[:notice] = 'Role was successfully created.'
        format.html { redirect_to(@role) }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to(@role) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
    end
  end

  private
  def genCondition
    s = ""
    ad = ""
    h = Hash.new
    if has_value params[:name]
      s << ad
      s << " name like :name"
      h[:name] = "%#{params[:name]}%"
      ad = " and"
    end   
    if has_value params[:created_at]
      s << ad
      s << " created_at >= :created_at"
      h[:created_at] = "#{params[:created_at]}"
      ad = " and"
    end
    [s, h]
  end


  def genJoins
    s = []
    if has_value(params[:username])
      # s << " inner join users on consumptions.user_id = users.id"
    end
    s
  end

  def genOrder
    s =" id desc"
  end

end
