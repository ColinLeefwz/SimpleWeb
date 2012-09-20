require 'eventmachine'

module Handler
   def file_modified
     puts "#{path} modified"
   end

   def file_moved
     puts "#{path} moved"
   end

   def file_deleted
     puts "#{path} deleted"
   end

   def unbind
     puts "#{path} monitoring ceased"
   end
 end

 EM.kqueue = true if EM.kqueue? # file watching requires kqueue on OSX

 EM.run {
   EM.watch_file("/tmp/foo", Handler)
 }