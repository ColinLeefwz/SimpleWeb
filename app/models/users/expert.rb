class Expert < Member
  has_many :sessions, dependent: :destroy
  has_and_belongs_to_many :courses
  has_many :video_interviews
  has_many :resources
	has_many :video_interviews
	has_one :intro_video, as: :introable, dependent: :destroy

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :intro_video
  # alias_method :profile=, :profile_attributes=   # NOTE add this line for active admin working properly

  # after_create :build_profile

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

  # private
  # def build_profile
		# logger.info "after create expert"
  #   self.profile || self.create_profile
  # end

end
