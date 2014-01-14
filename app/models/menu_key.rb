class MenuKey
  include Mongoid::Document
  field :_id, type: String #key
  field :type, type: String #类型
  field :tv 

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
  end
  
  
  
  
end