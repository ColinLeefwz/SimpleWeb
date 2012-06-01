class FollowInfoController < ApplicationController
  
  
  def followers
    fs = Follow.find_all_by_follow_id params[:id]
    ret = []
    fs.each {|f| ret << User.find_by_id(f.user_id)}
    render :json => ret.to_json
  end
  
  def friends
    fs = Follow.find_all_by_user_id params[:id]
    ret = []
    fs.each {|f| ret << User.find_by_id(f.follow_id)}
    render :json => ret.to_json
  end
  
  
end
