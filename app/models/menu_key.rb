class MenuKey
  include Mongoid::Document
  field :_id, type: String #key
  field :type, type: String #类型
  field :tv 
  
  def shop_id
    self.id[1..-1].split("_")[0]
  end
  
  def shop
    Shop.find_by_id(shop_id)
  end

  def self.content(key)
  	MenuKey.find_by_id(key).content
  end

  def content
  	case type
  	when 'text'
  		tv
  	when 'photo'
  		Photo.find_by_id(tv).img.url(:t2)
  	when 'faq'
  		'问答：' + ShopFaq.find_by_id(tv).title
  	end
    rescue 
      ""
  end
  
  def send_to_user(uid)
  	case type
  	when 'text'
  		Xmpp.send_gchat2(shop.msg_sender, shop_id, uid, tv)
  	when 'photo'
  		photo = Photo.find_by_id(tv)
      Xmpp.send_gchat2(shop.msg_sender, shop_id, uid, "[img:#{photo._id}]#{photo.desc_multi}")
  	when 'faq'
  		faq = ShopFaq.find_by_id(tv)
      faq.send_to_room(uid)
  	end
  end  
  
  
end