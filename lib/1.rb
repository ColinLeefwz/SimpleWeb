if $0 == __FILE__  

puts File.dirname(__FILE__) + '/lock.rb'
require File.dirname(__FILE__) + '/fs_lock.rb'

while true
	FSLock.new('/tmp/myapp') do  
		puts "1:>>#{Time.now}"
		sleep 1
		puts "1:>>#{Time.now}"
		sleep 1
		puts "1:>>#{Time.now}"
		sleep 1
	  end  
	sleep 1

end

end