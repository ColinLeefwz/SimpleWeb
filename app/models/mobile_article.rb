class MobileArticle

  include Mongoid::Document

  field :sid, type: Integer
  field :title
  field :text #简单摘要
  field :img

  field :category

  field :content

  field :kw #关键字

  mount_uploader(:img, MobileArticleImgUploader)

  def self.img_url(id,type=nil)
    if type
      "http://oss.aliyuncs.com/dface/#{id}/#{type}_0.jpg"
    else
      "http://oss.aliyuncs.com/dface/#{id}/0.jpg"
    end
  end
  
  def self.create_stub(sid,seq)
    ma = MobileArticle.new
    ma.id = "[#{sid}]#{seq}"
    ma.save
  end
  
  $fake_articles = ["",""]
  
  class << self
    alias_method :find_by_id_old, :find_by_id unless method_defined?(:find_by_id_old)
    alias_method :find_old, :find unless method_defined?(:find_old)
  end
  
  def self.find_by_id(aid)
    return nil if aid.nil?
    if aid.class==String && aid[0]=="["
      find_by_id_old($fake_articles[0])
    else
      find_by_id_old(aid)
    end
  end
  
  def self.find(aid)
    return nil if aid.nil?
    if aid.class==String && aid[0]=="["
      find_old($fake_articles[0])
    else
      find_old(aid)
    end
  end


end