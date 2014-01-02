class Profile < ActiveRecord::Base
  belongs_to :user
  before_save :check_web_site


  private
  # make sure the URL starts with `http` protocol, so that link_to works properly
  def check_web_site
    if /^http/.match(self.web_site) == nil
      self.web_site = "http://" + self.web_site
    end
  end
end
