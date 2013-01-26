# encoding: utf-8

class WeiboFriend
  @queue = :normal

  def self.perform(token, wb_uid, uid)
    data = SinaFriend.new.insert_ids(wb_uid,token)
  end
end