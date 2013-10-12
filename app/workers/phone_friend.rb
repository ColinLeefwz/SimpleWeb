# encoding: utf-8

class PhoneFriend
  @queue = :normal

  def self.perform(uid)
    user = User.find_by_id(uid)
    user = User.find_primary(uid) if user.nil?

    newbind_notice_all_oldbind(user)
    all_oldbind_notice_newbind(user)
  end

  def self.newbind_notice_all_oldbind(user)
    user.address_list_frends.each do |x|
      PhoneFriend.friend_notice(x,user)
    end
  end

  def self.all_oldbind_notice_newbind(user)
    user.address_list_frends.each do |x|
      PhoneFriend.friend_notice(user.x)
    end
  end
  
  def self.friend_notice(user,x)
    phone = x.phone if x.phone
    Xmpp.send_chat(x.id,user.id,": 您的通讯录中手机号为#{phone}的用户也在使用脸脸，在脸脸中也加TA为好友吧。")
  end
end