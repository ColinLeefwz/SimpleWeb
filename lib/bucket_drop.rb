require 'riak'

def drop(name)
client = Riak::Client.new
bucket = client[name]
bucket.keys.each {|k| Riak::RObject.new(bucket, k).delete }
end
