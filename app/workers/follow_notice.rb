# encoding: utf-8

class FollowNotice
  @queue = :xmpp

  def self.perform(uid,tid)
    return unless UserFollow.find_or_new(uid, tid)
    user = User.find_by_id(uid)
    user = User.find_primary(uid) if user.nil?
    loc = User.last_loc_cache(tid)
    loc = User.last_loc_cache(uid) if loc.nil?
    if loc && loc[1]
      str = "你在#{loc[1]}"
    else
      str = ""
    end
    Xmpp.send_chat(uid,tid,": #{user.name}看到#{str}并关注了你噢~", "FOLLOW#{uid},#{tid}") #多次关注消息ID一致，防止消息重发
  end
  
end
