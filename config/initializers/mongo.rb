
#Mongoid.logger = Logger.new($stdout)
Mongoid.logger = Rails.logger


module Moped

  # The cluster represents a cluster of MongoDB server nodes, either a single
  # node, a replica set, or a mongos server.
  class Cluster

    def nodes
	    #puts "disable Node Discovery."
      @nodes
    end

    def refresh(nodes_to_refresh = @nodes)
      @nodes.each {|node| node.refresh}
      @nodes
    end

    def with_primary(retry_on_failure = true, &block)
      return yield nodes[0]
    end
  end

  class Node
    def refresh
	@primary = true
    end
  end
end


