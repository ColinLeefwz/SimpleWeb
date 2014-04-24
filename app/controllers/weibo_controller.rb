class WeiboController < ApplicationController
  before_filter :user_login_filter
  before_filter :user_is_session_user
  before_filter :bind_weibo_filter

  def relation
    wb_users = remote_users($redis.get("wbtoken#{session[:user_id]}"))
    return render :json => {error: 'token过期'} if wb_users['error']
    users = User.where({wb_uid: {'$in' => wb_users.keys}})
    user_ids = users.distinct(:wb_uid)
    follow_ids = session_user.follow_ids
    to_invite = wb_users.keep_if{|k, v| !k.in?(user_ids)}.values
    friend = users.select{|user| user.id.to_s.in?(follow_ids)}.map{|user| user.safe_output}
    to_add = (users - friend).map{|user| user.safe_output}
    render :json => {to_add: to_add, friend: friend, to_invite: to_invite}.to_json
  end 

  private
  #请求微博关注api， 三次请求失败返回{"users" => [], 'next_cursor' => 0 }
  def visit_remote(token, cursor=0, time=0)
    return {"users" => [], 'next_cursor' => 0 } if time >2
    url = "https://api.weibo.com/2/friendships/friends.json"
    hash= {access_token: token, uid: session_user.wb_uid, count: 200, cursor: cursor}
    begin
      JSON.parse RestClient.get(url+ "?" + hash.to_param)
    rescue RestClient::BadRequest
      {'error' => true}
    rescue 
      visit_remote(token, cursor, time+1)
    end
  end

  # 用户的关注列表 {id1 => {id => id1,name=> 'xxx' ...}, id2 => {id => id2,name=> 'xxx' ...}, .... }
  def remote_users(token)
    users = {}
    cursor = 0
    while true
      wb_users = visit_remote(token, cursor)
      return {'error' => true} if wb_users['error']
      wb_column = ['id', 'name', 'description', 'profile_image_url', 'gender','avatar_hd']
      wb_users['users'].each{|wb_user| users[wb_user['id'].to_s] = wb_user.select{|k,v| k.in?(wb_column)} }
      return users if (cursor = wb_users['next_cursor'].to_i) == 0 
    end
  end 


  def bind_weibo_filter
    render :json => 0 if session_user.wb_uid.blank?
  end

end