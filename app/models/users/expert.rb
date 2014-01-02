class Expert < Member
  has_many :sessions, dependent: :destroy
  has_and_belongs_to_many :courses
  has_many :resources
	has_many :video_interviews
	has_one :intro_video, as: :introable, dependent: :destroy

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :intro_video
  alias_method :profile=, :profile_attributes=   # NOTE add this line for active admin working properly


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
    self.sessions.where("content_type = 'ArticleSession'").order("draft desc")
  end

  def live_sessions
    self.sessions.where("content_type = 'LiveSession'").order("draft desc")
  end

end
