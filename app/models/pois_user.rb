# encoding: utf-8
class PoisUser
  include Mongoid::Document
  attr_accessor :count
  store_in session: "dooo"

  def pois_users_insert(token, poiid)
    @count = 50
    sucoll, datas =   SinaUser.collection, []
    total_number = single_page(token, poiid)["total_number"]
    1.upto((total_number-1)/count+1) do |page|
      single_page(token, poiid, page)['users'].each do |r|
        datas << [r["id"], r["status"]['text'], r["status"]['source'], r["checkin_at"]]
        id = r.delete("id")
        sucoll.insert({:_id =>  id }.merge(user_get_attributes(r))) unless SinaUser.find_by_id(id)
      end
    end
    SinaPoi.find(poiid).update_attribute(:datas, datas)
  end

  private
  def single_page(token, poiid, page=1, err_num = 0)
    #    sleep(3)
    url =  "https://api.weibo.com/2/place/pois/users.json?poiid=#{poiid}&access_token=#{token}&count=#{count}&page=#{page}"
    begin
      response = RestClient.get(url)
    rescue
      err_num += 1
      return nil if err_num == 4
      sleep 1 * 60
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaFriend#PoisUser get #{url}错误，. #{$!}"
      return single_page(token, poiid, page, err_num)
    end
    response = JSON.parse response
  end

  def user_get_attributes(uhash)
    uhash.slice("screen_name","description","profile_image_url","gender","followers_count","friends_count","statuses_count",
      "favourites_count","created_at","allow_all_act_msg","geo_enabled","verified","verified_type","remark",
      "allow_all_comment","avatar_large","verified_reason")
  end

end
