class FollowsController < ApplicationController
  # GET /follows
  # GET /follows.json
  def index
    @follows = Follow.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @follows }
    end
  end


  # POST /follows
  # POST /follows.json
  def create
    if params[:user_id].to_i != session[:user_id]
      render :json => {:error => "user #{params[:user_id]} != session user #{session[:user_id]}"}.to_json
      return
    end
    @follow = Follow.new
    @follow.user_id = params[:user_id]
    @follow.follow_id = params[:follow_id]
    if @follow.save
      render :json => @follow.to_json
    else
      render :json => {:error => "follow save failed"}.to_json
    end
  end

  def delete
    if params[:user_id].to_i != session[:user_id]
      render :json => {:error => "user #{params[:user_id]} != session user #{session[:user_id]}"}.to_json
      return
    end
    follow = Follow.find_by_user_id_and_follow_id(session[:user_id],params[:follow_id])
    if follow.destroy
      render :json => {:deleted => params[:follow_id]}.to_json
    else
      render :json => {:error => "follow #{params[:id]} delete failed"}.to_json
    end
  end


  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy

    respond_to do |format|
      format.html { redirect_to follows_url }
      format.json { head :no_content }
    end
  end
end
