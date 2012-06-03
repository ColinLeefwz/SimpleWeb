module Openfire
  def self.included(c)
      c.establish_connection "openfire".to_sym
  end  
end
