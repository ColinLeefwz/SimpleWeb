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

  def category_count(category)
    category_count = Article.where("'#{category.name}' = ANY(categories)").count + VideoInterview.where("'#{category.name}' = ANY(categories)").count + Announcement.where("'#{category.name}' = ANY(categories)").count
  end

  def all_count
    all_count = Article.count + VideoInterview.count + Announcement.count
  end

  def video_interview_count
    video_interview_count = VideoInterview.count
  end

  def article_count
    article_count = Article.count
  end

  def announcement_count
    announcement_count = Announcement.count
  end

end
