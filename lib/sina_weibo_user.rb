class SinaWeiboUser
  attr_accessor :id
  attr_accessor :screen_name
  attr_accessor :province
  attr_accessor :city
  attr_accessor :location
  attr_accessor :description
  attr_accessor :url
  attr_accessor :profile_image_url
  attr_accessor :domain
  attr_accessor :gender
  attr_accessor :followers_count
  attr_accessor :friends_count
  attr_accessor :statuses_count
  attr_accessor :favourites_count
  attr_accessor :created_at
  attr_accessor :following
  attr_accessor :verified
  attr_accessor :allow_all_act_msg
  attr_accessor :geo_enabled
  attr_accessor :status

  def initialize(id, screen_name, province, city, location, description, url, profile_image_url, domain, gender, followers_count, friends_count, statuses_count, favourites_count, created_at, following, verified, allow_all_act_msg, geo_enabled, status)
    self.id = id
    self.screen_name = screen_name
    self.province = province
    self.city = city
    self.location = location
    self.description = description
    self.url = url
    self.profile_image_url = profile_image_url
    self.domain = domain
    self.gender = gender
    self.followers_count = followers_count
    self.friends_count = friends_count
    self.statuses_count = statuses_count
    self.favourites_count = favourites_count
    self.created_at = created_at
    self.following = following
    self.verified = verified
    self.allow_all_act_msg = allow_all_act_msg
    self.geo_enabled = geo_enabled
    self.status = status
  end
end
