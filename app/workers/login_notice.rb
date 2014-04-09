# encoding: utf-8

class LoginNotice
  @queue = :normal

  def self.perform(uid, session_id, reg=false)
    save_session(uid,session_id)
    #user = User.find_by_id(uid)
    #cpd = CouponDown.where({uid:user.id, :uat => {"$exists" => false} }).last
    #cpd.xmpp_send if cpd
  end
  
  def self.save_session(uid, session_id)
    begin
      old = SessionUser.find(session_id)
      if old.uid.to_s == uid.to_s
        Xmpp.error_notify("系统#{old.user.os}版本#{old.user.ver}用户：#{old.user.name} 重复登录. 注册时间#{old.user.cat},上次登录时间#{old.create_time},当前时间 #{Time.now}")
      else
        Xmpp.error_notify("同一个session：#{session_id},不同的用户：#{old.user.name} , #{User.find_by_id(uid).name}")
      end
      return
    rescue  Exception => e
      Rails.logger.error "------------CheckLogin-----------"
      Rails.logger.error e
      Rails.logger.error e.backtrace
    end
    su = SessionUser.new
    su._id = session_id
    su.uid = uid
    su.c_at = Time.now.to_i
    su.save!
  end
  
end
