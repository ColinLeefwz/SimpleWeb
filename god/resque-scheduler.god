rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/lianlian"

God.watch do |w|
    w.dir      = "#{rails_root}"
    w.log = "#{rails_root}/log/resque-scheduler.log"
    w.env      = {"RAILS_ENV"=>rails_env}
  w.name = "resque-scheduler"
  w.start = "rake resque:scheduler"
  w.keepalive
end

