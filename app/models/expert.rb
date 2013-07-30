class Expert < ActiveRecord::Base
  validates :name, presence: true
  has_many :sessions, dependent: :destroy    
end
