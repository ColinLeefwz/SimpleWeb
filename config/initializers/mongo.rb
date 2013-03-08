
#Mongoid.logger = Logger.new($stdout)
Mongoid.logger = Rails.logger
Mongoid.identity_map_enabled = true


module Mongoid
  module Finders
    def find_by_id(id)
      begin
        find(id)
      rescue
        Rails.logger.info "#{self.name}: #{id} not exists."
        nil
      end
    end
    
    def find_primary(id) #只通过replset的主数据库查询
      self.collection.database.session.cluster.with_primary do |node|
        db = self.collection.database.name
        coll = self.to_s.pluralize.underscore
        id2 = self.fields["_id"].mongoize(id)
        obj = node.query(db,coll,{_id:id2}).documents[0]
        obj = self.instantiate(obj) unless obj.nil?
        #从hash结果new一个对象会导致id变化
        return obj
      end
    end    
    
  end
end

module Mongoid
  module Document
    def cat
      self._id.generation_time.getlocal
    end
    
    def cati
      self._id.to_s[0,8].to_i(16)
    end
    
    def cats
      (Time.at self._id.to_s[0,8].to_i(16)).strftime("%Y-%m-%d %H:%M:%S")
    end
    
  end
end

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


