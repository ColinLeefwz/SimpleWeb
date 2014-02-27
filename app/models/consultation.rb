class Consultation < ActiveRecord::Base
  belongs_to :requester
  belongs_to :consultant
end
