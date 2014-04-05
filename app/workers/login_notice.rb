# encoding: utf-8

class LoginNotice
  @queue = :normal

  def self.perform(uid, session_id, reg=false)
    su = SessionUser.new
    su._id = session_id
    su.uid = uid
    su.cat = Time.now.to_i
    su.save!
    #user = User.find_by_id(uid)
    #cpd = CouponDown.where({uid:user.id, :uat => {"$exists" => false} }).last
    #cpd.xmpp_send if cpd
  end
  
end
