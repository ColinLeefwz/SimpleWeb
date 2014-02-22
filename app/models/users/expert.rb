class Expert < Member
  has_many :articles, dependent: :destroy
  has_and_belongs_to_many :courses
  has_many :video_interviews, -> {order "updated_at DESC"}
  has_many :resources

  has_one :video, as: :videoable, dependent: :destroy
  accepts_nested_attributes_for :video, allow_destroy: true

  accepts_nested_attributes_for :profile
  # alias_method :profile=, :profile_attributes=   # NOTE add this line for active admin working properly

  after_create :create_a_profile, :create_a_video

  def name
    "#{first_name} #{last_name}"
  end

  def name_with_inital
    "#{first_name.first}. #{last_name}"
  end

  def password_required?
    new_record? ? false : super
  end

  def contents
    articles = self.articles
    video_interviews = self.video_interviews

    (articles+video_interviews).sort{|x,y| y.updated_at <=> x.updated_at}
  end

  def is_staff
    return (self.id == 2)
  end

  def self.staff
    @staff || User.find(2)
  end

  private
  def create_a_profile
    self.create_profile
  end

  def create_a_video
    self.create_video
  end

end
