
#Mongoid.logger = Logger.new($stdout)
Mongoid.logger = Rails.logger
Paperclip.options[:log] = false  
