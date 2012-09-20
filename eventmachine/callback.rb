require 'eventmachine'

module DumbHttpClient
   def post_init
     send_data "GET / HTTP/1.1\r\nHost: _\r\n\r\n"
     @data = ""
     @parsed = false
   end

   def receive_data data
     @data << data
     if !@parsed and @data =~ /[\n][\r]*[\n]/m
       @parsed = true
       puts "RECEIVED HTTP HEADER:"
       puts @data
       #@data.each {|line| puts ">>> #{line}" }

       puts "Now we'll terminate the loop, which will also close the connection"
       EventMachine::stop_event_loop
     end
   end

   def unbind
     puts "A connection has terminated"
   end
 end

 EventMachine::run {
   EventMachine::connect "www.dface.cn", 80, DumbHttpClient
 }
 puts "The event loop has ended"
 