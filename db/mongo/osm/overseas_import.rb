# coding: utf-8
require 'OSM/objects'
require 'OSM/StreamParser'

class MyCallbacks < OSM::Callbacks
  def node(node)
    oversea = Oversea.new
    oversea.id = node.id
    if node.tags["is_in:country"]
      oversea.country = node.tags["is_in:country"]
    elsif  node.tags["is_in"]
      oversea.country = node.tags["is_in"].split(/,|;/).last.strip
    end
    return if oversea.country == 'China'
    if node.tags["name:zh"]
      oversea.city=node.tags["name:zh"]
    elsif node.tags["name:en"]
      oversea.city=node.tags["name:en"]
    else
      oversea.city=node.tags["name"]
    end

    if node.tags["is_in:country"]
      oversea.country = node.tags["is_in:country"]
    elsif  node.tags["is_in"]
      oversea.country = node.tags["is_in"].split(/,|;/).last.strip
    end

    oversea.lo = [node.lat.to_f, node.lon.to_f]

    oversea.save

  end
end

cb = MyCallbacks.new
parser = OSM::StreamParser.new(:filename => '/mnt/oversea_place.osm', :callbacks => cb)
parser.parse