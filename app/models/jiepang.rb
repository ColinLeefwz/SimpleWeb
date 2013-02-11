# encoding: utf-8
class Jiepang
  Logger = Logger.new('log/jiepang.log', 0, 100 * 1024 * 1024)

  include Mongoid::Document
  store_in session: "dooo"
  
  def self.insert(lo)
    datas = Jiepang.get_loc(lo)
    return if datas.nil?
    datas["items"].each do |x|
      x["_id"] = x["guid"]
      x.delete("guid")
      Jiepang.collection.insert(x)
    end
  end
  
  def self.get_loc(lo,err_num=0)
    url = "http://api.jiepang.com/v1/discover/featured_locations?lat=#{lo[0]}&lon=#{lo[1]}&count=100&source=100760"
    begin
      response = RestClient.get(url)
      Logger.info "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} get #{url}"
    rescue RestClient::BadRequest
      return nil
    rescue
      err_num += 1
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} get #{url}错误#{err_num}次. #{$!}"
      Emailer.send_mail('Jiepang出错',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} get #{url}错误. #{$!}").deliver if err_num == 4
      return nil if err_num == 4
      sleep err_num * 20
      return self.get_loc(lo, err_num)
    end
    JSON.parse response
  end

end
