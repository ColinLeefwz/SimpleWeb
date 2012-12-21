# encoding: utf-8
class SinaFriend
  include Mongoid::Document
  store_in session: "dooo"

  def insert_ids(wb_uid, token)
    coll = self.collection
    coll.insert(:_id => wb_uid.to_s, :data => all_page(wb_uid,token))
  end

  private
  
  def single_page(wb_uid,token,cursor=0,err_num = 0)
    sleep(1.5)
    url = "https://api.weibo.com/2/friendships/friends/ids.json?count=#{5000}&cursor=#{cursor}&&access_token=#{token}&uid=#{wb_uid}"
    begin
      response = RestClient.get(url)
    rescue
      err_num += 1
      return nil if err_num == 4
      sleep 1 * 60
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaFriend#single_page get #{url}错误，. #{$!}"
      return single_page(wb_uid,token,cursor,err_num)
    end
    response = JSON.parse response
  end

  def all_page(wb_uid, token)
    data = single_page(wb_uid,token)
    return [] if data.nil?
    total_number = data["total_number"]
    ids = []
    0.upto((total_number-1)/5000) do |page|
      ids += single_page(wb_uid, token,page)["ids"].map{|m| m.to_s}
    end
    {:ids =>  ids, :total_number =>  total_number}
  end

end

























