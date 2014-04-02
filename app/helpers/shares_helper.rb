require 'open-uri'
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
