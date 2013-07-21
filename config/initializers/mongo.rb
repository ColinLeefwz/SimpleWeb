
#Mongoid.logger = Logger.new($stdout)
Mongoid.logger = Rails.logger
Mongoid.identity_map_enabled = false

module Mongoid
  module Finders
    
    def my_cache_key(id)
      "#{self.name}#{id}"
    end
    
    def find_by_id(id)
      key = my_cache_key(id)
      begin
        cache = Rails.cache.read(key)
        Rails.logger.debug "read cache:#{key} =>> #{cache}"
        return cache unless cache.nil?
      rescue
      end
      begin
        ret = find(id)
        Rails.cache.write(key,ret)
        ret
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
    
    def my_cache_key
      "#{self.class.name}#{_id}"
    end
    
    def update_my_cache
      key = my_cache_key
      Rails.logger.debug "update/delete cache:#{key}"
      #Rails.cache.write(key,self)
      Rails.cache.delete(key)
    end

    def del_my_cache
      key = my_cache_key
      Rails.logger.debug "delete cache: #{key}"
      Rails.cache.delete(key)
    end
    
    def set_my_cache
      Rails.cache.write(my_cache_key,self)
    end
    
#http://mongoid.org/en/mongoid/docs/persistence.html#atomic    
#使Atomic Persistence支持cache更新
#When executing atomic operations via these methods, no callbacks will ever get run, nor will any validations.
    def add_to_set_cache(field, value, options = {})
      add_to_set_without_cache(field, value, options)
      update_my_cache
    end
    
    def inc_cache(field, value, options = {})
      inc_without_cache(field, value, options)
      update_my_cache
    end
    
    def pop_cache(field, value, options = {})
      pop_without_cache(field, value, options)
      update_my_cache
    end
    
    def pull_cache(field, value, options = {})
      pull_without_cache(field, value, options)
      update_my_cache
    end
    
    def pull_all_cache(field, value, options = {})
      pull_all_without_cache(field, value, options)
      update_my_cache
    end

    def push_cache(field, value, options = {})
      push_without_cache(field, value, options)
      update_my_cache
    end
    
    def push_all_cache(field, value, options = {})
      push_all_without_cache(field, value, options)
      update_my_cache
    end
    
    def rename_cache(field, value, options = {})
      rename_without_cache(field, value, options)
      update_my_cache
    end
    
    def set_cache(field, options = {})
      set_without_cache(field, options)
      update_my_cache
    end
    
    def unset_cache(field, options = {})
      unset_without_cache(field, options)
      update_my_cache
    end
    
    
    def self.included(base)
      base.set_callback(:update, :after,  :update_my_cache)
      base.set_callback(:upsert, :after,  :update_my_cache)
      #base.set_callback(:save, :after,  :update_my_cache)
      base.set_callback(:destroy, :after,  :del_my_cache)
      base.class_eval do
        alias_method :add_to_set_without_cache, :add_to_set
        alias_method :add_to_set, :add_to_set_cache
        alias_method :inc_without_cache, :inc
        alias_method :inc, :inc_cache
        alias_method :pop_without_cache, :pop
        alias_method :pop, :pop_cache
        alias_method :pull_without_cache, :pull
        alias_method :pull, :pull_cache
        alias_method :pull_all_without_cache, :pull_all
        alias_method :pull_all, :pull_all_cache
        alias_method :push_without_cache, :push
        alias_method :push, :push_cache
        alias_method :push_all_without_cache, :push_all
        alias_method :push_all, :push_all_cache
        alias_method :rename_without_cache, :rename
        alias_method :rename, :rename_cache
        alias_method :set_without_cache, :set
        alias_method :set, :set_cache
        alias_method :unset_without_cache, :unset
        alias_method :unset, :unset_cache
      end
    end
    
    def cat
      self._id.generation_time.getlocal
    end
    
    def cati
      self._id.to_s[0,8].to_i(16)
    end
    
    def cats
      (Time.at self._id.to_s[0,8].to_i(16)).strftime("%Y-%m-%d %H:%M:%S")
    end

    def cat_day
      (Time.at self._id.to_s[0,8].to_i(16)).strftime("%Y-%m-%d")
    end
        
  end
end

module Moped

  # The cluster represents a cluster of MongoDB server nodes, either a single
  # node, a replica set, or a mongos server.
  class Cluster

    def nodes(opts = {})
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


