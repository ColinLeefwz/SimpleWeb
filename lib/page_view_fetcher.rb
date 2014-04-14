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
    queries.each do |q|
      type, id, param = extract_data(q)
      update_views(type, id, param, views)
    end
  end


  private
  def self.min_created_at
    array = %w(Article Announcement VideoInterview Course).map{|model| model.constantize.minimum(:created_at)}
    array.min
  end

  def self.extract_data(query)
    type, id, param, views = nil
    expression = /\/(?<type>\b(sessions|articles|courses|video_interviews|announcements)\b)\/(?<param>\d+[\w-]*)$/

    result = expression.match query
    if result
      type = result[:type].classify
      param = result[:param]
      id = param.to_i
      views = query.pageviews.to_i
    end

    [type, id, param, views]
  end

  def self.update_views(type, id, param, views)
    return unless type && id && param && views

    record = type.constantize.find id
    if record.to_param == param
      visit = Visit.find_or_create_by(visitable_id: id, visitable_type: type)
      visit.update_attributes(page_views: views)
    end
  end
end

