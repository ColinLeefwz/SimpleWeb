# encoding: utf-8
class SinaPoi
  include Mongoid::Document
  attr_accessor :count
  store_in session: "dooo"

  def pois_insert(token,lo)
    @count = 50
    coll = self.collection
    total_number = pois(token, lo)["total_number"]
    1.upto((total_number-1)/count+1) do |page|
      pois(token,lo, page)["pois"].each do |d|
        id = d.delete("poiid")
        if coll.find({:_id => id}).to_a.blank?
          if ba = check_baidu(d['title'], [d['lat'], d['lon']])
            d.merge!({"baidu_id" => ba._id})
          end
          coll.insert({:_id => id }.merge(d))
        end
      end
    end
  end





  def check_baidu(name, lo)
    baidu = Baidu.where({:name => name, :lo => {"$within" => {"$center" => [lo, 0.01]}}}).to_a.first
    return baidu if baidu
    
    if name.last==')'
      name2 = name.gsub(/[()]/, '')
      baidu = Baidu.where({:name => name2,:lo => {"$within" => {"$center" => [lo,0.002]}}}).to_a.first
      return baidu if baidu
    end
    
    nil
  end

  private
  def pois(token,lo, page=1, err_num = 0)
    sleep(3)
    url = "https://api.weibo.com/2/place/nearby/pois.json?count=#{count}&page=#{page}&lat=#{lo[0]}&long=#{lo[1]}&access_token=#{token}"
    begin
      response = RestClient.get(url)
    rescue
      err_num += 1
      return nil if err_num == 4
      sleep 1 * 60
      $LOG.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaPoi#pois get #{url}错误，. #{$!}"
      return pois(token,lo, page,err_num)
    end
    JSON.parse response
  end



end
