class Consultation < ActiveRecord::Base
  STATUS = {pending: "pending", processed: "processed", accepted: "accepted", rejected: "rejected", finished: "finished"}

  belongs_to :requester, class_name: "User"
  belongs_to :consultant, class_name: "User"
end
