require 'mandrill_api'

class User < ActiveRecord::Base
	include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:facebook, :linkedin]

  has_and_belongs_to_many :enrolled_sessions, class_name: 'Session'
  has_many :orders
  has_many :email_messages
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"}

	def enroll_session(session)
		self.enrolled_sessions << session
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
end
