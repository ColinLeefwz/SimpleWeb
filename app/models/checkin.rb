class Checkin < ActiveRecord::Base
  belongs_to :mshop
  belongs_to :user
end
