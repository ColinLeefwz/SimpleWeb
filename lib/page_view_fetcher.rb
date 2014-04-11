require 'google/api_client'
require 'page_view'

class PageViewFetcher
  def self.user_authorization(scope="https://www.googleapis.com/auth/analytics.readonly")
    client = Google::APIClient.new(
      :application_name => "Prodygia",
      :application_version => "1.0"
    )
    key = Google::APIClient::PKCS12.load_key(ENV['PRIVATE_KEY_NAME'], "notasecret")
    service_account = Google::APIClient::JWTAsserter.new("114507681566-nagtao2ud8vh0a872icve2hhksr5rdsr@developer.gserviceaccount.com", scope, key)
    client.authorization = service_account.authorize
    oauth_client = OAuth2::Client.new("", "", {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'
    })
    token = OAuth2::AccessToken.new(oauth_client, client.authorization.access_token)
    Legato::User.new(token)
  end

  def self.fetch_page_views(user)
    profile = user.profiles.first
    PageView.results(profile, start_date: min_created_at)
  end

  def self.process_data(queries)
    expression = /\/(?<type>\b(sessions|articles|courses|video_interviews|announcements)\b)\/(?<id>\d+)[\w-]*$/

    queries.each do |query|
      result = expression.match(query.pagePath) 
      if result
        visitable_type = result[:type].singularize.camelize
        visitable_id = result[:id].to_i
        page_views = query.pageviews.to_i

        visit = Visit.where(visitable_id: visitable_id, visitable_type: visitable_type).first_or_create
        visit.update_attributes(page_views: page_views)
      end
    end
  end


  private
  def min_created_at
    array = %w(Article Announcement VideoInterview Course).map{|model| model.constantize.minimum(:created_at)}
    array.min
  end

end
