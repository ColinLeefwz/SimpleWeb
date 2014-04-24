class EmailMessage < ActiveRecord::Base
  MESSAGE_TYPE = { refer: "refer", share: "share" }.freeze
  belongs_to :user

  validates :to, presence: true

  attr_accessor :item_url
end
