# encoding: utf-8

class LocationNotice
  @queue = :normal

  def self.perform(uid,sid)
    user = User.find_by_id(uid)
    shop = Shop.find_by_id(sid)
    user.notify_good_friend(shop)
  end
  
end
