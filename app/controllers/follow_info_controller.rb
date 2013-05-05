class FollowInfoController < ApplicationController
  
  
  def followers
    who = User.find_by_id(params[:id])   
    users = who.followers
    #TODO: redis端分页
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
    #TODO: mongodb端分页
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
    #TODO: redis端分页
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    output_users(users.reverse)
  end
  
  
end
