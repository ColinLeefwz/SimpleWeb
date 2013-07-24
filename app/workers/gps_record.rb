# encoding: utf-8

class GpsRecord
  @queue = :normal

  def self.perform(hash)
    GpsLog.collection.insert(hash)
  end
  
end
