rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/lianlian"

God.watch do |w|
    w.dir      = "#{rails_root}"
    w.log = "#{rails_root}/log/sina.log"
    w.env      = {"RAILS_ENV"=>rails_env}
  w.name = "sina"
  w.start = "rails r HeatLoc.start"
  w.keepalive
end

