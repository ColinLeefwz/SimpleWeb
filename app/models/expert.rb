class Expert < ActiveRecord::Base
  validates :name, presence: true,
	        length: {minimum: 10}
  has_many :sessions, dependent: :destroy    
end
