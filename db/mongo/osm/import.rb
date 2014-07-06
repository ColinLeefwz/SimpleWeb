
require 'OSM/objects'
require 'OSM/StreamParser'

class MyCallbacks < OSM::Callbacks
  def initialize
    @id = Shop.last.id.to_i
    @count = 0
  end
    def node(node)
      @id +=1
		  @count += 1
      shop = Shop.new
      shop.id = @id
      shop.osm_id = node.id
      if node.tags["name:zh"]
        shop.name = node.tags["name:zh"]
        shop.t = 99
      else
        shop.name = node.tags["name"]
      end
      shop.lo = [node.lat.to_f,node.lon.to_f]   
      shop.save!
    end
    attr_accessor :count
end

cb = MyCallbacks.new
parser = OSM::StreamParser.new(:filename => '/Users/ylt/lianlian/place.osm', :callbacks => cb)
parser.parse
puts "all:#{cb.count}"