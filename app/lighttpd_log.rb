ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../config/environment"

$running = true;
Signal.trap("TERM") do
  $running = false
end

File.open("/tmp/lighttpd_log_rails","w") do |f|
  if f.flock(File::LOCK_EX | File::LOCK_NB)
    file = File.open("/var/log/lighttpd/access_1dooo.log")
    file.seek(0,IO::SEEK_END)
    while($running) do
      begin
        ss = file.readline.split(" ")
	alog = Access2Log.new
	alog.ip = ss[0]
	alog.created_at = ss[3]
	alog.url = ss[6] 
	alog.status = ss[8] 
	alog.len = ss[9] 
	alog.time = ss[10]
	alog.referer = ss[11]
	alog.save!
      rescue EOFError => eof
        sleep 1
      rescue Exception => error
        puts "##{error.class}##{error}"
        sleep 1
      end
    end
    f.flock(File::LOCK_UN)
  else
    Sms.log "another instance of lighttpd_log job is running?"
  end
end
