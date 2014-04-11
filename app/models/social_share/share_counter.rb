require 'open-uri'
require 'net/http'
require 'json'

class ShareCounter
  def initialize(url)
    @url = url
  end

  def facebook
    request = open "http://graph.facebook.com/?id=#{@url}"
    response = request.read
    JSON.parse(response)['shares'] || 0
  end


  def linked_in
    request = open "http://www.linkedin.com/countserv/count/share?format=json&url=#{@url}"
    response = request.read
    JSON.parse(response)['count'] || 0
  end


  def twitter
    request = open "http://urls.api.twitter.com/1/urls/count.json?url=#{@url}"
    response = request.read
    JSON.parse(response)['count'] || 0
  end


  def google_plus
    response = JSON.parse request_google_plus_api
    response["result"]["metadata"]["globalCounts"]["count"].to_i || 0
  end

  


  private
  def request_google_plus_api
    uri = URI("https://clients6.google.com/rpc?key=#{ENV['GOOGLE_API_KEY']}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    post = Net::HTTP::Post.new(uri.path, {"Content-Type" => "application/json"})
    post.body = {method: "pos.plusones.get", id: "p", params: {nolog: true, id: @url, source: "widget", userId: "@viewer", groupId: "@self"}, jsonrpc: "2.0", key: "p", apiVersion: "v1"}.to_json

    http.request(post).body
  end
end

