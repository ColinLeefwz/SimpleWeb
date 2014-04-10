require 'open-uri'
require 'net/http'
require 'json'

module SharesHelper
  def get_fb_shares(url)
    json_content = open('http://graph.facebook.com/?id=' + url)
    shares = JSON.parse json_content.read
    shares['shares'] || 0
  end

  def get_li_shares(url)
    json_content = open('http://www.linkedin.com/countserv/count/share?format=json&url=' + url)
    shares = JSON.parse json_content.read
    shares['count'] || 0
  end

  def get_tw_shares(url)
    json_content = open('http://urls.api.twitter.com/1/urls/count.json?url='+ url)
    shares = JSON.parse json_content.read
    shares['count'] || 0
  end

  def get_gp_shares(url)
    data = {method: "pos.plusones.get", id: "p", params: {nolog: true, id: url, source: "widget", userId: "@viewer", groupId: "@self"}, jsonrpc: "2.0", key: "p", apiVersion: "v1"}

    query_uri = URI("https://clients6.google.com/rpc?key=#{ENV['GOOGLE_API_KEY']}")
    query_request = Net::HTTP::Post.new(query_uri.path, {"Content-Type" => "application/json"})
    query_request.body = data.to_json
    http = Net::HTTP.new(query_uri.host, query_uri.port)
    http.use_ssl = true
    query_response = http.request(query_request)

    json_content = JSON.parse query_response.body
    json_content["result"]["metadata"]["globalCounts"]["count"].to_i || 0
  end

  def copyright_notice_year_range(start_year)
    start_year = start_year.to_i

    current_year = Time.new.year

    if current_year > start_year
      "#{start_year} - #{current_year}"
    else
      "#{current_year}"
    end
  end

  def model_count(klazz)
    klazz.constantize.count
  end

  def all_count
    all_count = Article.count + VideoInterview.count + Announcement.count
  end

end
