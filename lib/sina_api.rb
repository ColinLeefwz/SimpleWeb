class SinaApi


  class FriendIDs
    @@count = 5000
    def single_page(wb_uid,token,cursor=0)
      response = RestClient.get "https://api.weibo.com/2/friendships/friends/ids.json?count=#{@@count}&cursor=#{cursor}&&access_token=#{token}&uid=#{wb_uid}"
      puts "https://api.weibo.com/2/friendships/friends/ids.json?count=#{@@count}&cursor=#{cursor}&&access_token=#{token}&uid=#{wb_uid}"
      response = JSON.parse response
    end

    def all_page(wb_uid, token)
      data = single_page(wb_uid,token)
      total_number = data["total_number"]
      ids = data['ids'].map{|m| m.to_s}
      1.upto((total_number-1)/@@count) do |page|
        ids += single_page(wb_uid, token,page)["ids"].map{|m| m.to_s}
      end
      {:ids =>  ids, :total_number =>  total_number}
    end

    def insert_ids(wb_uid, token)
      if ENV["RAILS_ENV"] == "production"
        conn = Mongo::Connection.new("192.168.1.22")
      else
        conn = Mongo::Connection.new("127.0.0.1")
      end
      db = conn.db("dface")
      coll = db.collection("sina_friends")
      coll.insert(:_id => wb_uid.to_s, :data => all_page(wb_uid,token))
    end
  end

  class Poiis
    attr_accessor :count
    def initialize(hash={})
      @count = hash[:count]||50
    end

    def pois(token,lo, page=1)
      response = RestClient.get "https://api.weibo.com/2/place/nearby/pois.json?count=#{count}&page=#{page}&lat=#{lo[0]}&long=#{lo[1]}&access_token=#{token}"
      JSON.parse response
    end
    
    def get_coll
      if ENV["RAILS_ENV"] == "production"
        conn = Mongo::Connection.new("192.168.1.22")
      else
        conn = Mongo::Connection.new("127.0.0.1")
      end
      db = conn.db("dface")
      db.collection("sina_pois")
    end

    def pois_insert(token,lo)
      coll = get_coll
      data =  pois(token, lo)
      data['pois'].each do |d|
        id = d.delete("poiid")
        coll.insert({:_id => id }.merge(d)) if coll.find({:_id =>  id}).to_a.blank?
      end
      total_number = data["total_number"]
      2.upto((total_number-1)/count+1) do |page|
        pois(token,lo, page)["pois"].each do |d|
          id = d.delete("poiid")
          coll.insert({:_id => id }.merge(d)) if coll.find({:_id => id}).to_a.blank?
        end
      end
    end
  end

  class PoisUsers
    attr_accessor :count
    def initialize(hash={})
      @count = hash[:count]||50
    end

    def get_sucoll
      if ENV["RAILS_ENV"] == "production"
        conn = Mongo::Connection.new("192.168.1.22")
      else
        conn = Mongo::Connection.new("127.0.0.1")
      end
      db = conn.db("dface")
      db.collection("sina_users")
    end

    def get_coll
      if ENV["RAILS_ENV"] == "production"
        conn = Mongo::Connection.new("192.168.1.22")
      else
        conn = Mongo::Connection.new("127.0.0.1")
      end
      db = conn.db("dface")
      db.collection("sina_pois")
    end

    def single_page(token, poiid, page=1)
      response = RestClient.get "https://api.weibo.com/2/place/pois/users.json?poiid=#{poiid}&access_token=#{token}&count=#{count}&page=#{page}"
      puts "'https://api.weibo.com/2/place/pois/users.json?poiid=#{poiid}&access_token=#{token}&count=#{count}&page=#{page}'"
      response = JSON.parse response
    end

    def pois_users_insert(token, poiid)
      coll = get_coll
      sucoll = get_sucoll
      datas = []
      response = single_page(token, poiid)
      total_number = response["total_number"]
      response['users'].each do |r|
        datas << [r["id"], r["status"]['text'], r["status"]['source'], r["checkin_at"]]
        id = r.delete("id")
        sucoll.insert({:_id => id }.merge(r)) unless SinaUser.find_by_id(id)
      end
      2.upto((total_number-1)/count+1) do |page|
        response = single_page(token, poiid, page)
        response['users'].each do |r|
          datas << [r["id"], r["status"]['text'], r["status"]['source'], r["checkin_at"]]
          id = r.delete("id")
          sucoll.insert({:_id =>  id }.merge(r)) unless SinaUser.find_by_id(id)
        end
      end
      coll.update({:_id => poiid},{"$set" => {:datas => datas}})
    end
  end

end