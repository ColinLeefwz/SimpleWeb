module Sqlserver
  def self.included(c)
    if ENV["RAILS_ENV"] == "production"
      c.establish_connection "sqlserver".to_sym
    end
  end  
end
