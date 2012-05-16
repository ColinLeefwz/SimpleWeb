class AdminLoginLog < ActiveRecord::Base
  validates_presence_of :login_time, :ip
end




# == Schema Information
#
# Table name: admin_login_logs
#
#  id         :integer(4)      not null, primary key
#  login_time :datetime        not null
#  ip         :string(255)     not null
#  name       :string(255)
#  password   :string(255)
#  login_suc  :boolean(1)
#  admin_id   :integer(4)
#

