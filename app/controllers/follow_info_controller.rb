class FollowInfoController < ApplicationController
  
  
  def followers
    fs = Follow.find_all_by_follow_id params[:id]
    ret = []
    fs.each {|f| ret << f.user.safe_output }
    ret << {:count => fs.size}
    render :json => ret.to_json
  end
  
  def friends
    fs = Follow.find_all_by_user_id params[:id]
    ret = []
    fs.each {|f| ret << f.follow.safe_output }
    ret << {:count => fs.size}
    render :json => ret.to_json
  end
  
  
end
