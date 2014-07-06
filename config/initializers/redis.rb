if Rails.env=="production"
  $redis = Redis.new(:host => '10.200.141.172', :port => 6379)  
else
  $redis = Redis.new(:host => 'localhost', :port => 6379)
end
Resque.redis = $redis
