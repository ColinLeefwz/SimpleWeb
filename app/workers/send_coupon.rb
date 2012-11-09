class SendCoupon
  @queue = :normal

  def self.perform(user_id, shop_id )
    Shop.find(shop_id).send_coupon(user_id)
  end
end