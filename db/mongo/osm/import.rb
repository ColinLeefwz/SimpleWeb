
require 'OSM/objects'
require 'OSM/StreamParser'

class MyCallbacks < OSM::Callbacks
  def initialize
    @count = Shop.count
  end
    def node(node)
		  @count += 1
		  if @count<10
        shop = Shop.new
        shop.id = @count
        shop.name = node.tags["name"]
        shop.lo = [node.lat.to_f,node.lon.to_f]   
        shop.save!
      end
    end
end

cb = MyCallbacks.new
parser = OSM::StreamParser.new(:filename => '/Users/ylt/data.osm', :callbacks => cb)
parser.parse