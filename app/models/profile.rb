class Profile < ActiveRecord::Base
  belongs_to :user
  before_save :check_web_site, :generate_location
  before_update :generate_location

  private
  # make sure the URL starts with `http` protocol, so that link_to works properly
  def check_web_site
    if self.web_site.present? and (/^http/.match(self.web_site) == nil)
      self.web_site = "http://" + self.web_site
    end
  end

  def generate_location
    logger.info "generate location"
    self.location = "#{self.city} #{self.country}"
  end
end
