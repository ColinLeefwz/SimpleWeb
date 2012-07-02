class BlacklistsController < ApplicationController
  # GET /blacklists
  # GET /blacklists.json
  def index
    @blacklists = Blacklist.paginate(:conditions => genCondition(params[:id].to_i), :include => :user,:page => params[:page], :per_page => 20)
    @all_length = Blacklist.count(:all,:conditions => genCondition(params[:id].to_i), :include => :user)
    puts_users
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
  
  private

  def genCondition(id)
    sql = "blacklists.user_id = ?"
    a = [id]
    unless  params[:name].blank?
      sql += " and users.name like ? "
      a << "%#{params[:name]}%"
    end
    a.unshift(sql)
  end
  
  def puts_users
    users = []
    @blacklists.each {|f| users << f.block.safe_output } if @blacklists
    if params[:hash]
      ret = {:count => @all_length}
      ret.merge!( {:data => users})
    else
      ret = [{:count => @all_length}]
      ret << {:data => users}
    end
    render :json => ret.to_json
  end
  
  
end
