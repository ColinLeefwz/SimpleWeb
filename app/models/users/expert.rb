class Expert < Member
  include ActiveAdmin::Callbacks

  has_many :landingitems
  has_many :articles, dependent: :destroy
  has_and_belongs_to_many :courses
  has_many :video_interviews, -> {order "updated_at DESC"}

  has_one :video, as: :videoable, dependent: :destroy
  accepts_nested_attributes_for :video, allow_destroy: true

  accepts_nested_attributes_for :profile
  # alias_method :profile=, :profile_attributes=   # NOTE add this line for active admin working properly

  before_create :set_pwd
  after_create :create_association

  def name_with_inital
    # "#{first_name.first}. #{last_name}" ## Peter at 2014-04-08: use full name for now
    "#{first_name} #{last_name}"
  end

  def password_required?
    new_record? ? false : super
  end

  def contents
    fetch_contents
  end

  def published_contents
    fetch_contents(draft: false)
  end

  def is_staff
    return (self.id == 2)
  end

  def load_landingitems(point)
    all_items = []
    self.landingitems.where(draft: false).limit(6).offset(point * 6).each do |item|
      all_items << item.landingable_type.constantize.find(item.landingable_id)
    end
    all_items
  end

  def self.staff
    @staff || User.find(2)
  end

  private
  def set_pwd
    self.password ||= "logintochina"
  end
  def create_association
    self.profile ||= self.create_profile
    self.video ||= self.create_video
  end

  def fetch_contents(article_option = {})
    articles = Article.includes(:visit).where(expert_id: self.id).where(article_option)
    video_interviews = VideoInterview.includes(:visit).where(expert_id: self.id)
    (articles+video_interviews).sort{|x,y| y.updated_at <=> x.updated_at}
  end

end
