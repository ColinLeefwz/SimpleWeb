# encoding: utf-8
class SinaAdvt
  include Mongoid::Document
  extend RequestApi
  store_in session: "dooo"
  cattr_accessor :mtime, :ftime
  Log =  Logger.new('log/weibo/sina_advt.log', 0, 100 * 1024 * 1024)
  request_sina :create_com, Log
  request_sina :place_timeline, Log
  request_sina :geo_to_address, Log

  def self.create_comment
    places = place_timelines
    return unless places.is_a?(Array)
    places.each do |place|
      url = "https://api.weibo.com/2/comments/create.json"
      poi = get_poi(place)
      token = get_token(place['user']['gender'])
      #      params = {"id" => place['id'], "access_token"=> token, "comment" => comment(poi) }
      params = {"id" => '3560414669383960', "access_token"=> token, "comment" => comment(poi) }
      create_com(:url => url, :method => :post, :params => params )
    end
  end

  #  #  private

  def self.place_timelines
    url = "https://api.weibo.com/2/place/public_timeline.json"
    response =  place_timeline(:url => url, :method => :get, :params => {:access_token=> $sina_token, :count => 5}, :email_title => "获取最新公共的位置动态接口出错")
    return unless response.is_a?(Hash)
    response['statuses']
  end

  def comment(poi)
    "用手机应用#脸脸#" + poi.blank? ? '' : "在'#{poi}' " + "签到更好玩，能够看到同一地点签到的人，还可能获得特别优惠，赶快试试吧。下载地址： http://www.dface.cn/a?v=20"
  end

  def self.get_poi(place)
    poi = place['annotations']
    if poi.nil?
      lo = place['geo']['coordinates']
      url = "https://api.weibo.com/2/location/geo/geo_to_address.json"
      lo = lo.reverse.join(',')
      params = {:access_token=> $sina_token, :coordinate => lo}
      res = geo_to_address(:url => url, :method => :get, :params => params)
      return if res.nil?
      geo = res['geos'].first
      address = geo['address']
      name = geo['name']
      address+name
    else
      poi.first['place']['title']
    end
  end
  
  def self.get_token(gender)
    uid = comment_uid(gender)
    puts "#{uid}"
    $redis.get("wbtoken#{uid}")
  end
  
  def self.comment_uid(gender)
    if gender == 'm'
      @@ftime = @@ftime.to_i+1
      $fakeusers2[ftime%$fakeusers2.length]
    else
      @@mtime = @@mtime.to_i + 1
      $fakeusers1[mtime%$fakeusers1.length]
    end
  end
end