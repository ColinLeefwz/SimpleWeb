class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :owned_sessions, class_name: 'Session', foreign_key: 'owner_id'
	has_many :followed_sessions, class_name: 'Session'

end
