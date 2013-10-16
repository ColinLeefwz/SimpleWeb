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
    user.address_list_friends.each do |x|
      PhoneFriend.friend_notice1(user,x)
    end
    puser = user.who_de_address_list_has_you
    if puser.size>0
      puser.each do |x|
        PhoneFriend.friend_notice2(user,x)
      end
    end
  end  
  
  def self.friend_notice1(user,x)
    phone = x.phone if x.phone
    Xmpp.send_chat(x.id,user.id,": 您的通讯录中手机号为#{phone}的用户也在使用脸脸，在脸脸中也加TA为好友吧。")
  end

  def self.friend_notice2(user,x)
    phone = x.phone if x.phone
    Xmpp.send_chat(x.id,user.id,": 我是#{phone}，也在使用脸脸，快来关注我吧。")
  end
end