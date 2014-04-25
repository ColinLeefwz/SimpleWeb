# encoding: utf-8

class PhoneFriend
  @queue = :normal

  def self.perform(uid)
    user = User.find_by_id(uid)
    user = User.find_primary(uid) if user.nil?

    newbind_notice_all_oldbind(user)
  end

  # 当新用户A注册或绑定手机时通知A通讯录中已有的脸脸老用户,当用户A通讯录中有新用户注册或者绑定手机时通知A
  def self.newbind_notice_all_oldbind(user)
    arr = user.address_list_to_add + user.who_de_address_list_has_you
    arr.uniq!
    arr.each do |x|
      PhoneFriend.friend_notice(user,x)
    end
  end
  
  def self.friend_notice(user,x)
    Xmpp.send_chat(x.id,user.id,"我也在使用脸脸，快来关注我吧。")
  end

end