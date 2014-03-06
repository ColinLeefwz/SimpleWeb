class Expert < Member
  include ActiveAdmin::Callbacks

  has_many :articles, dependent: :destroy
  has_and_belongs_to_many :courses
  has_many :video_interviews, -> {order "updated_at DESC"}
  has_many :resources

  has_one :video, as: :videoable, dependent: :destroy
  accepts_nested_attributes_for :video, allow_destroy: true

  accepts_nested_attributes_for :profile
  # alias_method :profile=, :profile_attributes=   # NOTE add this line for active admin working properly

  define_active_admin_callbacks :save
  after_save :create_association

  def name_with_inital
    "#{first_name.first}. #{last_name}"
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

  def self.staff
    @staff || User.find(2)
  end

  def save
    run_save_callbacks do
      save!
    end
  end

  private
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
