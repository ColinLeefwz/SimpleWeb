class SinaWeiboStatus
  attr_accessor :id
  attr_accessor :created_at
  attr_accessor :text
  attr_accessor :source
  attr_accessor :favorited
  attr_accessor :truncated
  attr_accessor :geo
  attr_accessor :in_reply_to_status_id
  attr_accessor :in_reply_to_user_id
  attr_accessor :in_reply_to_screen_name

  def initialize(id, created_at, text, source, favorited, truncated, geo, in_reply_to_status_id, in_reply_to_user_id, in_reply_to_screen_name)
    self.id = id
    self.created_at = created_at
    self.text = text
    self.source = source
    self.favorited = favorited
    self.truncated = truncated
    self.geo = geo
    self.in_reply_to_status_id = in_reply_to_status_id
    self.in_reply_to_user_id = in_reply_to_user_id
    self.in_reply_to_screen_name = in_reply_to_screen_name
  end
end
