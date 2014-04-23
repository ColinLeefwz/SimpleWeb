require 'mandrill_api'

class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  USER_TYPE = { member: "Member", expert: "Expert" }

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"}

  has_one :profile
  has_many :comments

  # User follow sessions
  has_many :subscriptions, foreign_key: "subscriber_id"

  has_many :subscribed_sessions, through: :subscriptions, source: :subscribable, source_type: "Article"
  has_many :subscribed_courses, through: :subscriptions, source: :subscribable, source_type: "Course"
  has_many :subscribed_video_interviews, through: :subscriptions, source: :subscribable, source_type: "VideoInterview"
  has_many :subscribed_announcements, through: :subscriptions, source: :subscribable, source_type: "Announcement"

  # follow
  has_many :followed_records, class_name: 'Following', foreign_key: "followed_id", dependent: :destroy   # user is followed by others
  has_many :following_records, class_name: "Following", foreign_key: "follower_id", dependent: :destroy    # user follows someone else

  has_many :followers, through: :followed_records, class_name: "User"
  has_many :followings, through: :following_records, class_name: "User"

  # enrollments and orders
  has_many :enrollments
  has_many :enrolled_courses, through: :enrollments, source: :enrollable, source_type: "Course"

  has_many :orders
  has_many :email_messages

  # consultations
  has_many :sent_consultations, class_name: "Consultation", foreign_key: "requester_id"
  has_many :received_consultations, class_name: "Consultation", foreign_key: "consultant_id"

  # other available modules are: :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
  # Peter: we remove the :validatable to allow us to create multiple email with different provider
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :omniauthable, omniauth_providers: [:facebook, :linkedin]

  ## validations
  validates_presence_of   :email, :if => :email_required?
  validates_format_of     :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_uniqueness_of :email, scope: [:provider]

  validates   :user_name, presence: true, uniqueness: true

  validates_presence_of     :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_length_of       :password, :within => Devise.password_length, :allow_blank => true

  after_create :check_newsletter
  after_destroy :unsubscribe_newsletter

  after_create :create_activity_stream
  after_destroy :destroy_activity_stream

  def to_param
    user_name
  end

  def self.find(input)
    input.to_i == 0 ? find_by(user_name: input) : super
  end

  def self.user_name_duplicated?(user_name)
    count = where(user_name: user_name).count
    count > 0 ? true : false
  end

  def name
    "#{first_name} #{last_name}"
  end

  def subscribed_contents
    articles = self.subscribed_sessions
    video_interviews = self.subscribed_video_interviews
    announcements = self.subscribed_announcements
    (announcements + articles + video_interviews).sort{|x,y| x.updated_at <=> y.updated_at}
  end

  def has_subscribed? (item)
    Subscription.find_by(subscriber_id: self.id,
                         subscribable_id: item.id,
                         subscribable_type: item.class.name)
  end

  def subscribe (item)
    Subscription.create(subscriber_id: self.id,
                        subscribable_id: item.id,
                        subscribable_type: item.class.name )
  end

  def unsubscribe (item)
    record = Subscription.find_by(subscriber_id: self.id,
                                  subscribable_id: item.id,
                                  subscribable_type: item.class.name)
    record.destroy if record
  end


  def enrolled?(item)
    record = Enrollment.find_by user_id: self.id, enrollable_id: item.id, enrollable_type: item.class.name
    return record ? true : false
  end

  def enroll(item)
    record = Enrollment.create user_id: self.id, enrollable_id: item.id, enrollable_type: item.class.name
  end


  def build_refer_message(invited_type)
    self.email_messages.build(from_name: "#{self.first_name} #{self.last_name}", from_address: "no-reply@prodygia", reply_to: "#{self.email}", invited_type: invited_type)
  end

  ## Peter at 2014-04-15: these code should be extracted out to UserService
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first_or_create do |user|
      user.first_name = auth.extra.raw_info.first_name
      user.last_name = auth.extra.raw_info.last_name
      user.user_name = "#{user.name} facebook".parameterize
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.find_for_linkedin(access_token, sign_in_resource=nil)
    data = access_token.info
    user = User.where(email: data["email"], provider: 'linkedin').first_or_create do |user|
      user.first_name = data['first_name']
      user.last_name = data['last_name']
      user.user_name = "#{user.name} linkedin".parameterize
      user.email = data['email']
      user.password = Devise.friendly_token[0,20]
    end
  end

  protected
  ## override devise notification
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args)
  end

  ## copy the methods from Devise/lib/models/validatable.rb
  # because we remove the "validatable" model
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    true
  end

  def check_newsletter
    return if !self.subscribe_newsletter

    subscription = UserSubscription.new(self, ENV['MAILCHIMP_LIST_ID'])
    subscription.toggle(:create)
  end

  def unsubscribe_newsletter
    subscription = UserSubscription.new(self, ENV['MAILCHIMP_LIST_ID'])
    subscription.toggle(:destroy) if subscription.subscribed?
  end

  def create_activity_stream
    ActivityStream.create user_id: self.id
  end

  def destroy_activity_stream
    activity_stream = ActivityStream.where(user_id: self.id).first
    activity_stream.destroy if activity_stream
  end
end
