class DepartsController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  def initialize
    @menu_tag_id = 9
  end
  
  # GET /departs
  # GET /departs.xml
  def index
@departs = Depart.paginate(:conditions => genCondition, :joins => genJoins, :order => genOrder, :page => params[:page], :per_page =>20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @departs }
    end
  end

  # GET /departs/1
  # GET /departs/1.xml
  def show
    @depart = Depart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @depart }
    end
  end

  # GET /departs/new
  # GET /departs/new.xml
  def new
    @depart = Depart.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @depart }
    end
  end

  # GET /departs/1/edit
  def edit
    @depart = Depart.find(params[:id])
  end

  # POST /departs
  # POST /departs.xml
  def create
    @depart = Depart.new(params[:depart])

    respond_to do |format|
      if @depart.save
        flash[:notice] = 'Depart was successfully created.'
        format.html { redirect_to(@depart) }
        format.xml  { render :xml => @depart, :status => :created, :location => @depart }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @depart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /departs/1
  # PUT /departs/1.xml
  def update
    @depart = Depart.find(params[:id])

    respond_to do |format|
      if @depart.update_attributes(params[:depart])
        flash[:notice] = 'Depart was successfully updated.'
        format.html { redirect_to(@depart) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @depart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /departs/1
  # DELETE /departs/1.xml
  def destroy
    @depart = Depart.find(params[:id])
    @depart.destroy

    respond_to do |format|
      format.html { redirect_to(departs_url) }
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
