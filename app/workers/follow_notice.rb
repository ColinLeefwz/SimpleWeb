# encoding: utf-8

class FollowNotice
  @queue = :xmpp

  def self.perform(uid,tid)
    UserFollow.find_or_new(uid, tid)
    user = User.find_by_id(uid)
    loc = User.last_loc_cache(tid)
    loc = User.last_loc_cache(uid) if loc.nil?
    Xmpp.send_chat(uid,tid,": #{user.name}在#{loc[1]}看到并关注了你噢~")
  end
  
end
