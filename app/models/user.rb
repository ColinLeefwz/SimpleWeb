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

	def enroll_session(session)
		self.enrolled_sessions << session
	end
end
