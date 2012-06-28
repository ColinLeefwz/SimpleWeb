class BlacklistsController < ApplicationController
  # GET /blacklists
  # GET /blacklists.json
  def index
    @blacklists = Blacklist.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @blacklists }
    end
  end

  # POST /follows
  # POST /follows.json
  def create
    if params[:user_id].to_i != session[:user_id]
      render :json => {:error => "user #{params[:user_id]} != session user #{session[:user_id]}"}.to_json
      return
    end
    @blacklist = Blacklist.new
    @blacklist.user_id = params[:user_id]
    @blacklist.block_id = params[:block_id]
    @blacklist.report = true if params[:report].to_i == 1
    if @blacklist.save
      render :json => @blacklist.attributes.to_json
    else
      render :json => {:error => "blacklist save failed"}.to_json
    end
  end

  def delete
    if params[:user_id].to_i != session[:user_id]
      render :json => {:error => "user #{params[:user_id]} != session user #{session[:user_id]}"}.to_json
      return
    end
    blist = Blacklist.find_by_user_id_and_block_id(session[:user_id],params[:block_id])
    blist.destroy
    render :json => {:deleted => params[:block_id]}.to_json
  end
  

  # DELETE /blacklists/1
  # DELETE /blacklists/1.json
  def destroy
    @blacklist = Blacklist.find(params[:id])
    @blacklist.destroy

    respond_to do |format|
      format.html { redirect_to blacklists_url }
      format.json { head :no_content }
    end
  end
end
