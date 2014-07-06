class AdminsController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  # GET /admins
  # GET /admins.xml
  def index
    @admins = Admin.where({})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
      format.js
    end
  end

  # GET /admins/1
  # GET /admins/1.xml
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/new
  # GET /admins/new.xml
  def new
    @admin = Admin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /admins
  # POST /admins.xml
  def create
    @admin = Admin.new(params[:admin])

    respond_to do |format|
      if @admin.save
        flash[:notice] = 'Admin was successfully created.'
        format.html { redirect_to(@admin) }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        flash[:notice] = 'Admin was successfully updated.'
        format.html { redirect_to(@admin) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def dest
    @admin = Admin.find(params[:id])
    right = Right.find_by_id(@admin.id)
    if right
      Rails.cache.delete("#{right.class.name}#{right.id}")
      right.destroy
    end
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url) }
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
    if has_value params[:clazz]
      s << ad
      s << " clazz like :clazz"
      h[:clazz] = "%#{params[:clazz]}%"
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

