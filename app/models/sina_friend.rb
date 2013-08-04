# encoding: utf-8
class SinaFriend
  
  Logger = Logger.new('log/weibo/sina_friend.log', 0, 100 * 1024 * 1024)
  
  include Mongoid::Document
  store_in({:database => "sina"})  if Rails.env != "test"
  
  
  field :_id, type: String
  field :data, type: Hash #{ids, total_number}


  def insert_ids(wb_uid, token)
    begin
      SinaFriend.find(wb_uid.to_s)
      return
    rescue
    end
    hash =  all_page(wb_uid,token)
    return nil if hash.nil? || hash[:total_number]==0
    SinaFriend.collection.insert(:_id => wb_uid.to_s, :data =>hash)
  end
  
  def init_all(token)
    User.where({auto:{"$ne" => true}}).each do |user|
      next if user.wb_uid.nil? || !user.wb_uid.match(/^[\d]+$/)
      insert_ids(user.wb_uid,token)
      sleep(2)
    end
  end
  
  def init_poi_user(token=$sina_token)
    SinaUser.where({fetched:{"$ne" => true}}).each do |su|
      insert_ids(su.id,token)
      su.update_attribute(:fetched, true)
      sleep(10*Os.cur_load)
    end
  end

  private
  
  def single_page(wb_uid,token,cursor=0,err_num = 0)
    url = "https://api.weibo.com/2/friendships/friends/ids.json?count=#{5000}&cursor=#{cursor}&&access_token=#{token}&uid=#{wb_uid}"
    begin
      response = RestClient.get(url)
    rescue Exception => e
      puts e
      return nil
      err_num += 1
      return nil if err_num == 4
      sleep err_num*2
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaFriend#single_page get #{url}错误，. #{$!}"
      return single_page(wb_uid,token,cursor,err_num)
    end
    response = JSON.parse response
  end

  def all_page(wb_uid, token)
    data = single_page(wb_uid,token)
    return nil if data.nil?
    return {:ids =>  data["ids"], :total_number =>  data["total_number"]}
    #后面重复抓取，其实不需要，超过5000直接忽略。
    total_number = data["total_number"]
    ids = []
    0.upto((total_number-1)/5000) do |page|
      xx = single_page(wb_uid, token,page)["ids"]
      return nil if xx.nil?
      ids += xx.map{|m| m.to_s}
    end
    {:ids =>  ids, :total_number =>  total_number}
  end

end

























