require 'mandrill_api'

class User < ActiveRecord::Base
	include Rails.application.routes.url_helpers

	USER_TYPE = { member: "Member", expert: "Expert" }

  has_one :profile

	## User follow sessions
  has_many :subscriptions, foreign_key: "subscriber_id"
  has_many :subscribed_sessions, through: :subscriptions

	## User follows User
  has_many :be_followed, class_name: 'Relationship', foreign_key: "followed_id"
  has_many :followers, through: :be_followed, class_name: "User"

  has_many :following, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followed_users, through: :following, class_name: "User"

  has_and_belongs_to_many :enrolled_sessions, class_name: 'Session'
  has_many :orders
  has_many :email_messages
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"}, default_url: 'missing.png'
	
	# other available modules are: :token_authenticatable, :confirmable, :lockable, :timeoutable and :omniauthable
	# Peter: we remove the :validatable to allow us to create multiple email with different provider
	devise :invitable, :database_authenticatable, :registerable, :recoverable, 
		:rememberable, :trackable, :omniauthable, omniauth_providers: [:facebook, :linkedin]

	## validations
	validates_presence_of   :email, :if => :email_required?
	validates_format_of     :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
	validates_uniqueness_of :email, scope: [:provider]

	validates_presence_of     :password, :if => :password_required?
	validates_confirmation_of :password, :if => :password_required?
	validates_length_of       :password, :within => Devise.password_length, :allow_blank => true

	## methods for subscribe sessions
  def has_subscribed? (this_session)
    self.subscribed_sessions.include? (this_session)
  end

  def subscribe (this_session)
    self.subscribed_sessions << this_session
  end

  def unsubscribe (this_session)
    self.subscribed_sessions.delete this_session
  end

	## methods for follow users
	def follow? (other_user)
		self.followed_users.include? (other_user)
	end

	def	follow(followed_user)
		self.followed_users << followed_user
	end

  def unfollow(followed_user)
    self.followed_users.delete followed_users
  end

	def enroll_session(session)
		self.enrolled_sessions << session
	end

  def build_refer_message(invited_type)
    self.email_messages.build(from_name: "#{self.first_name} #{self.last_name}", from_address: "no-reply@prodygia", reply_to: "#{self.email}", invited_type: invited_type)
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name: auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: auth.info.email,
                         password: Devise.friendly_token[0,20]
                        )
    end
    user
  end

	def self.find_for_linkedin(access_token, sign_in_resource=nil)
		data = access_token.info
		user = User.where(email: data["email"], provider: data["provider"]).first

		unless user
			user = User.create(email: data["email"],
												 password: Devise.friendly_token[0,20])
		end
		user
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

end
