#wget http://downloads.cloudmade.com/asia/eastern_asia/china/zhejiang/zhejiang.osm.bz2
#grep -o '[一-龥]' zhejiang.osm

#gem install osmlib-base

require 'OSM/objects'
require 'OSM/StreamParser'

class MyCallbacks < OSM::Callbacks
  def initialize
    @count = 0
  end
    def node(node)
		  @count += 1
		  puts node if @count<10
    end
end

cb = MyCallbacks.new
parser = OSM::StreamParser.new(:filename => 'zhejiang.osm', :callbacks => cb)
parser.parse