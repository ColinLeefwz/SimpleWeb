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

  def show
    @checkin = Checkin.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checkin }
    end
  end
  
  # POST /checkins
  # POST /checkins.json
  def create
    @checkin = Checkin.new
    @checkin.loc = [params[:lat].to_f, params[:lng].to_f]
    @checkin.accuracy = params[:accuracy]
    @checkin.user_id = params[:user_id]
    @checkin.shop_id = params[:shop_id]
    @checkin.shop_name = params[:shop_name]
    @checkin.od = params[:od]
    @checkin.ip = real_ip
    @checkin.cat = Time.now

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
