# encoding: utf-8

class LoginNotice
  @queue = :normal

  def self.perform(uid)
    user = User.find_by_id(uid)
    #cpd = CouponDown.where({uid:user.id, :uat => {"$exists" => false} }).last
    #cpd.xmpp_send if cpd
  end
  
end