class BlacklistsController < ApplicationController
  before_filter :user_is_session_user, :except => [:index]

  def index
    users = User.find(params[:id]).blacks_s.map {|x| User.where({_id:x["id"]}).first }
    users.delete(nil)
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    output_users(users)
  end

  def create
    hash = {id:Moped::BSON::ObjectId(params[:block_id]), report:params[:report].to_i }
    session_user.add_to_set(:blacks, hash)
    render:json => hash.to_json
  end

  def delete
    session_user.pull(:blacks,{id:Moped::BSON::ObjectId(params[:block_id])})
    render :json => {:deleted => params[:block_id]}.to_json
  end
  
  
end
