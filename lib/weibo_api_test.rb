
def session_user
  User.find_by_id(session[:user_id])
end

def session
  {:user_id => '502e6303421aa918ba000007'}
end

def token
  '2.00kfdvGCGFlsXC1b5e64ba39QaSfpB'
end


def relation
    wb_users = remote_users(token)
    # wb_users = remote_users($redis.get("wbtoken#{session[:user_id]}"))
    return {error: 'token过期'} if wb_users['error']
    users = User.where({wb_uid: {'$in' => wb_users.keys}})
    wb_uids = users.distinct(:wb_uid)
    to_invite = wb_users.keep_if{|k, v| !k.in?(wb_uids) && v['follow_me']}.values
    friend, to_add =[], []
    users.each{|user| (user.id.to_s.in?(session_user.follow_ids) ? friend : to_add ) << user.safe_output}
    {to_add: to_add, friend: friend, to_invite: to_invite}
  end 

  #请求微博关注api， 三次请求失败返回［］
  def visit_remote(token, cursor=0, time=0)
    return {"users" => [], 'next_cursor' => 0 } if time >2
    url = "https://api.weibo.com/2/friendships/friends.json"
    hash= {access_token: token, uid: session_user.wb_uid, count: 200, cursor: cursor}
    begin
      puts url+ "?" + hash.to_param
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
      wb_column = ['id', 'name', 'description', 'profile_image_url', 'gender','avatar_hd', 'follow_me']
      wb_users['users'].each{|wb_user| users[wb_user['id'].to_s] = wb_user.select{|k,v| k.in?(wb_column)} }
      return users if (cursor = wb_users['next_cursor'].to_i) == 0 
    end
  end 
