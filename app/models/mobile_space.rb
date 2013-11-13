class MobileSpace
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :domain
  field :full_name
  field :description
  field :storage_used, :default => 0


  has_many :mobile_articles, :dependent => :delete
  # has_many :mobile_attachments, :dependent => :destroy
  belongs_to :shop

  index({ :shop_id => 1 })
  index({ :name => 1 }, { :unique => true })
  index({ :domain => 1 }, { :unique => true, :sparse => true})

  # validates :name, :presence => true, :uniqueness => {:case_sensitive => false}, :format => {:with => /\A[a-z0-9-]+\z/, :message => "不能为空" }, :length => {:in => 4..20}
  validates :domain, :format => {:with => /\A[a-zA-Z0-9_\-.]+\z/}, :uniqueness => {:case_sensitive => false}, :allow_blank => true


  def to_param
    name.to_s
  end

end
