class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  # has_many :owned_sessions, class_name: 'Session', foreign_key: 'owner_id'
  # has_many :followed_sessions, class_name: 'Session'

  has_and_belongs_to_many :enrolled_sessions, class_name: 'Session'
  has_many :orders
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>"}

  devise :omniauthable, :omniauth_providers => [:linkedin]

  def enroll_session(session)
    self.enrolled_sessions << session
  end

  def self.find_for_linkedin(access_token, sign_in_resource=nil)
    data = access_token.info
    user = User.where(email: data["email"]).first

    unless user 
      user = User.create(email: data["email"],
                         password: Devise.friendly_token[0,20])
    end

    user
  end
end
