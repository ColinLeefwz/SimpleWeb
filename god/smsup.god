rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/mnt/lianlian"

God.watch do |w|
    w.dir      = "#{rails_root}"
    w.log = "#{rails_root}/log/smsup.log"
  w.name = "smsup"
  w.start = "ruby lib/smsup.rb"
  w.keepalive
end

