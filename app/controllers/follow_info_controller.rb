class FollowInfoController < ApplicationController
  
  
  def followers
    hash = {follows: Moped::BSON::ObjectId(params[:id])}
    hash.merge!({name: /#{params[:name]}/})  unless params[:name].nil?
    users = User.where(hash)
    output_users(users)
  end
  
  def friends
    users = User.find(params[:id]).follows_s.map {|x| User.find2(x) }
    users.delete(nil)
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    output_users(users)
  end
  
  
end
