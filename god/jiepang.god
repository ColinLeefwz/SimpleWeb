rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/lianlian"

God.watch do |w|
    w.dir      = "#{rails_root}"
    w.log = "#{rails_root}/log/jp.log"
    w.env      = {"RAILS_ENV"=>rails_env}
  w.name = "jiepang"
  w.start = "rails r HeatLoc.jiepang"
  w.keepalive
end

