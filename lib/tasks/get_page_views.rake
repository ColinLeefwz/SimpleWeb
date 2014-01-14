require 'page_view_fetcher'

namespace :google_analytics do

  desc "update page views data"
  task :update_pageviews => :environment do
    user = PageViewFetcher.user_authorization()
    queries = PageViewFetcher.fetch_page_views(user)
    PageViewFetcher.process_data(queries)
    puts "update pageviews successfully"
  end
end
