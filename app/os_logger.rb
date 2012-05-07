ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../config/environment"

$running = true;
Signal.trap("TERM") do
  $running = false
end

$pages_in = nil
$pages_out = nil
$receive = nil
$transmit = nil

$sleep_time = 300

File.open("/tmp/os_log_rails","w") do |f|
  if f.flock(File::LOCK_EX | File::LOCK_NB)
    while($running) do
	olog = OsLog.new
	olog.load = Os.cpu_load
	olog.Active_MEM,olog.Cached_MEM,olog.Free_MEM,olog.SwapTotal  = Os.mem  
	if $pages_in.nil?
		$pages_in, $pages_out = Os.page_io
	else
		@pin,@pout = Os.page_io
		olog.PagesIn = @pin - $pages_in
		olog.PagesOut = @pout - $pages_out
		$pages_in, $pages_out = @pin,@pout
	end
	if $receive.nil?
		$receive,$transmit = Os.net_io
	else
		@nin,@nout = Os.net_io
		olog.Receive = @nin - $receive
		olog.Transmit = @nout - $transmit
		$receive,$transmit = @nin,@nout
	end
	states = Os.netstat
	olog.CONNECTIONS  = states.inject(0) {|sum,x| sum=sum+x[1]}
	states.each {|x| olog.write_attribute(x[0],x[1])}
	if olog.load>=2 ||  (!olog.PagesIn.nil? && olog.PagesIn>=500) || olog.CONNECTIONS>=6000
		olog.ps_info = `ps -eo pid,pcpu,time,rss,command | sort --key=2 -nr | head -n 15`
		$sleep_time = 60
	else
		$sleep_time = 300
	end
	olog.save!
	sleep $sleep_time
    end
    f.flock(File::LOCK_UN)
  else
    Sms.log "another instance of os_log job is running?"
  end
end
