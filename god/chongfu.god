rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/lianlian"

God.watch do |w|
    w.dir      = "#{rails_root}"
    w.log = "#{rails_root}/log/chongfu.log"
    w.env      = {"RAILS_ENV"=>rails_env}
  w.name = "chongfu"
  w.start = "rails r db/mongo/add/chongfu4.rb"
  w.keepalive
end

