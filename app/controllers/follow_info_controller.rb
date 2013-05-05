class FollowInfoController < ApplicationController
  
  
  def followers
    who = User.find_by_id(params[:id])   
    hash = {follows: who.id}
    users = UserFollow.only(:_id).where(hash).map {|x| User.find_by_id(x.id) }
    users.delete(nil)
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    users.delete_if {|x| who.black?(x._id) }
    output_users(users)
  end
  
  def friends
    who = UserFollow.find_by_id(params[:id])
    if who.nil?
      render :json => [].to_json
      return
    end
    users = who.follows.map {|x| User.find_by_id(x) }
    users.delete(nil)
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    output_users(users.reverse)
  end
  
  def good_friends
    who = User.find_by_id(params[:id])
    if who.nil?
      render :json => [].to_json
      return
    end
    users = who.good_friends
    users.delete(nil)
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    output_users(users.reverse)
  end
  
  
end
