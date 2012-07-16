class CheckinsController < ApplicationController
  # GET /checkins
  # GET /checkins.json
  def index
    #request.headers.keys.each do |key|
    #      logger.debug "#{key} : #{request.headers[key]}"
    #end
    @checkins = Checkin.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @checkins }
    end
  end

  # GET /checkins/1
  # GET /checkins/1.json
  def show
    @checkin = Checkin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checkin }
    end
  end

  # GET /checkins/new
  # GET /checkins/new.json
  def new
    @checkin = Checkin.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @checkin }
    end
  end

  # GET /checkins/1/edit
  def edit
    @checkin = Checkin.find(params[:id])
  end

  # POST /checkins
  # POST /checkins.json
  def create
    @checkin = Checkin.new
    @checkin.lat = params[:lat]
    @checkin.lng = params[:lng]
    @checkin.accuracy = params[:accuracy]
    @checkin.user_id = params[:user_id]
    @checkin.mshop_id = params[:mshop_id]
    @checkin.shop_name = params[:shop_name]
    @checkin.ip = real_ip
    @checkin.time = Time.now

    respond_to do |format|
      if @checkin.save
        format.html { redirect_to @checkin, :notice => 'Checkin was successfully created.' }
        format.json { render :json => @checkin, :status => :created, :location => @checkin }
      else
        format.html { render :action => "new" }
        format.json { render :json => @checkin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /checkins/1
  # PUT /checkins/1.json
  def update
    @checkin = Checkin.find(params[:id])

    respond_to do |format|
      if @checkin.update_attributes(params[:checkin])
        format.html { redirect_to @checkin, :notice => 'Checkin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @checkin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checkins/1
  # DELETE /checkins/1.json
  def destroy
    @checkin = Checkin.find(params[:id])
    @checkin.destroy

    respond_to do |format|
      format.html { redirect_to checkins_url }
      format.json { head :no_content }
    end
  end
end
