class EmailMessage < ActiveRecord::Base
  belongs_to :sender, class_name: Expert
end
