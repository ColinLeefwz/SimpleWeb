rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/lianlian"

God.watch do |w|
    w.dir      = "#{rails_root}"
    w.log = "#{rails_root}/log/offset.log"
    w.env      = {"RAILS_ENV"=>rails_env}
  w.name = "boffset"
  w.start = "rails r db/riak/migrate_offsetbaidu.rb"
  w.keepalive
end

