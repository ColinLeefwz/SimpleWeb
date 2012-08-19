class ShopNoticesController < ApplicationController
  # GET /shop_notices
  # GET /shop_notices.json
  def index
    if params[:id]
      @shop_notices = ShopNotice.where({shop_id: params[:id]})
    else
      @shop_notices = ShopNotice.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shop_notices.map{|sn| {id:sn._id, title:sn.title} }.to_json }
    end
  end

  # GET /shop_notices/1
  # GET /shop_notices/1.json
  def show
    @shop_notice = ShopNotice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @shop_notice }
    end
  end

  # GET /shop_notices/new
  # GET /shop_notices/new.json
  def new
    @shop_notice = ShopNotice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @shop_notice }
    end
  end

  # GET /shop_notices/1/edit
  def edit
    @shop_notice = ShopNotice.find(params[:id])
  end

  # POST /shop_notices
  # POST /shop_notices.json
  def create
    @shop_notice = ShopNotice.new(params[:shop_notice])

    respond_to do |format|
      if @shop_notice.save
        format.html { redirect_to @shop_notice, :notice => 'Shop notice was successfully created.' }
        format.json { render :json => @shop_notice, :status => :created, :location => @shop_notice }
      else
        format.html { render :action => "new" }
        format.json { render :json => @shop_notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shop_notices/1
  # PUT /shop_notices/1.json
  def update
    @shop_notice = ShopNotice.find(params[:id])

    respond_to do |format|
      if @shop_notice.update_attributes(params[:shop_notice])
        format.html { redirect_to @shop_notice, :notice => 'Shop notice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @shop_notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shop_notices/1
  # DELETE /shop_notices/1.json
  def destroy
    @shop_notice = ShopNotice.find(params[:id])
    @shop_notice.destroy

    respond_to do |format|
      format.html { redirect_to shop_notices_url }
      format.json { head :no_content }
    end
  end
end
