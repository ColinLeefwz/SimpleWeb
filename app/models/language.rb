class Language < ActiveRecord::Base
  def combine_version
    [self.long_version, self.short_version].join(",")
  end
end
