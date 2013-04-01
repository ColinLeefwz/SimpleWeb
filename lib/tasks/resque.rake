require "resque/tasks"
require 'resque_scheduler/tasks'

Resque.redis = '10.200.141.172:6379'  # all 3 values are optional

task "resque:setup" => :environment
