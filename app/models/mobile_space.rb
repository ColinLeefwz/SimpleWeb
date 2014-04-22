class MobileSpace
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in({:database => "mweb_production"}) if Rails.env.production?   
  store_in({:database => "mweb_development"}) if Rails.env.development?

  field :sid, type: Integer
  field :name
  field :domain
  field :full_name
  field :description
  field :menu, type: Array
  field :menu2, type: Array
  field :storage_used, :default => 0

  field :flag, :type => Boolean, :default => false

  # index({ :shop_id => 1 })
  # index({ :name => 1 }, { :unique => true })
  # index({ :domain => 1 }, { :unique => true, :sparse => true})

  # validates :name, :presence => true, :uniqueness => {:case_sensitive => false}, :format => {:with => /\A[a-z0-9-]+\z/, :message => "不能为空" }, :length => {:in => 4..20}
  # validates :domain, :format => {:with => /\A[a-zA-Z0-9_\-.]+\z/}, :uniqueness => {:case_sensitive => false}, :allow_blank => true


  def to_param
    name.to_s
  end

  scope :in_plan, -> plan {
    if plan.to_s == 'free'
      scoped.or({:plan => plan}, {:plan_expired_at.lt => Time.now})
    else
      where(:plan => plan, :plan_expired_at.gt => Time.now)
    end
  }

  def in_plan?(plan)
    if plan == :free
      self.plan == plan || plan_expired_at.blank? || plan_expired_at < Time.now
    else
      self.plan == plan && plan_expired_at.present? && plan_expired_at > Time.now
    end
  end

end
