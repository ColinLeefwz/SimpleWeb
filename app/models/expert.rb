class Expert < ActiveRecord::Base
  validates :name, presence: true
  has_many :sessions, dependent: :destroy    
  
  has_many :users, as: :rolable, dependent: :destroy
end
