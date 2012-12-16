
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

  end

  class Node
    
    alias :refresh_old :refresh
    
    def refresh
      if ip_address.to_s == "127.0.0.1"
        @primary = true
      else
        refresh_old
      end
    end
    
  end
  
end


