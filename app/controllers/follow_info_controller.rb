class FollowInfoController < ApplicationController
  
  
  def followers
    who = User.find_by_id(params[:id])
    hash = {follows: Moped::BSON::ObjectId(params[:id])}
    hash.merge!({name: /#{params[:name]}/})  unless params[:name].nil?
    users = User.where(hash).to_ary
    users.delete_if {|x| who.black?(x._id) }
    output_users(users)
  end
  
  def friends
    who = User.find_by_id(params[:id])
    users = who.follows_s.map {|x| User.find_by_id(x) }
    users.delete(nil)
    users.delete_if {|x| x.friend?(who.id)} if (session[:ver].to_f > 1.4 || session[:android])
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    users.delete_if {|x| who.black?(x._id) }
    output_users(users.reverse)
  end
  
  def good_friends
    who = User.find_by_id(params[:id])
    users = who.follows_s.map {|x| User.find_by_id(x) }
    users.delete(nil)
    users.delete_if {|x| !x.friend?(who.id)}
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    users.delete_if {|x| who.black?(x._id) }
    output_users(users.reverse)
  end
  
  
end
