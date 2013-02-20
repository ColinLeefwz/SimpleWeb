rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/lianlian"

God.watch do |w|
    w.dir      = "#{rails_root}"
    w.log = "#{rails_root}/log/sina_friend.log"
    w.env      = {"RAILS_ENV"=>rails_env}
  w.name = "sina_friend"
  w.start = "rails r SinaFriend.new.init_poi_user"
  w.keepalive
end

