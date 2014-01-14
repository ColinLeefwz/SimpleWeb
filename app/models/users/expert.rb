class Expert < Member
  has_many :sessions, dependent: :destroy
  has_and_belongs_to_many :courses
  has_many :video_interviews, -> {order "updated_at DESC"}
  has_many :resources
  has_one :intro_video, as: :introable, dependent: :destroy

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :intro_video
  # alias_method :profile=, :profile_attributes=   # NOTE add this line for active admin working properly

  after_create :create_a_profile

  def name
    "#{first_name} #{last_name}"
  end

  def password_required?
    new_record? ? false : super
  end

  def sessions_with_draft
    self.sessions.order('draft desc') 
  end

  def contents
    articles = self.sessions.where(content_type: "ArticleSession")
    video_interviews = self.video_interviews

    (articles+video_interviews).sort{|x,y| y.updated_at <=> x.updated_at}
  end

  def live_sessions
    self.sessions.where("content_type = 'LiveSession'").order("draft desc")
  end

  private
  def create_a_profile
    logger.info "create a profile automatically for a new expert"
      self.profile || self.create_profile
  end

end
