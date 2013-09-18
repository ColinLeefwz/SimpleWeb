class Expert < ActiveRecord::Base
  validates :name, presence: true
  has_many :sessions, dependent: :destroy    
  
  has_many :users, as: :rolable, dependent: :destroy

  has_attached_file :avatar
    # path: ":rails_root/public/system/experts/:attachment/:id partion/:style/:filename",
    # url: "/system/experts/:attachment/:id_partition/:style/:filename",

end
