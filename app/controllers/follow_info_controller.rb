class FollowInfoController < ApplicationController
  
  
  def followers
    who = User.find_by_id(params[:id])   
    users = who.fans
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    users.delete_if {|x| who.black?(x._id) }
    #TODO: 如何避免一次性加载所有数据
    output_users(users)
  end
  
  #deprecated
  def friends
    #Xmpp.error_notify("deprecated: follow_info/friends") if UserDevice.user_ver_redis(params[:id]).to_f>=2.4
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
  
  def friend_ids
    who = User.find_by_id(params[:id])
    if who.nil?
      render :json => [].to_json
      return
    end
    render :json => who.follow_ids.to_json
  end

  def friend_infos
    who = User.find_by_id(params[:id])
    if who.nil?
      render :json => [].to_json
      return
    end
    arr = who.follow_ids.map{|id| User.find_by_id(id)}.find_all{|x| x!=nil}
    render :json =>  arr.map{|u| u.safe_output}.to_json
  end
    
  #deprecated
  def good_friends
    #Xmpp.error_notify("deprecated: follow_info/good_friends")  if UserDevice.user_ver_redis(params[:id]).to_f>=2.4
    who = User.find_by_id(params[:id])
    if who.nil?
      render :json => [].to_json
      return
    end
    users = who.good_friends
    users.delete_if {|x| x.name.index(params[:name])==nil } unless params[:name].nil?
    output_users(users.reverse)
  end
  
  def good_friend_ids
    who = User.find_by_id(params[:id])
    if who.nil?
      render :json => [].to_json
      return
    end
    render :json => who.good_friend_ids.to_json
  end
  
  def friend_locs
    arr = params[:ids].split(",").map do |id|
      loc = User.last_loc_cache(id)
      {id:id}.merge(User.find_by_id(id).last_loc_to_hash(loc))
    end
    render :json => arr.to_json
  end
  
  def good_friend_locs
    friend_locs
  end

  def fan_locs
    friend_locs
  end
    
end
