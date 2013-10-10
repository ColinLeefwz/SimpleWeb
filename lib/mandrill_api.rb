require 'mandrill'
class MandrillApi
  def initialize
    @mandrill = Mandrill::API.new ENV['MANDRILL_API']
  end

  def template_send(user, session, template_name)
    template_content = [{"name" => "first-name", "content" => user.first_name}, {"name" => "session-title", "content" => session.title }, {"name" => "expert-name", "content" => session.expert.name}, {"name" => "start-date", "content" => session.start_date }]
    message = {
      "bcc_address"=>"message.bcc_address@example.com",
      "subject"=>"Session enrolled confirmation",
      "text"=>"Example text content",
      "metadata"=>{"website"=>"www.prodygia.com"},
      "view_content_link"=>nil,
      "auto_text"=>nil,
      "important"=>false,
      "to"=>[{"name"=>user.first_name, "email"=>user.email}],
      "tracking_domain"=>nil,
      "from_name"=>"Team Prodygia",
      "from_email"=>"support@prodygia.com",
      "inline_css"=>nil,
      "headers"=>{"Reply-To"=>"no-reply@prodygia.com"}
    }

    async = false
    ip_pool = "Main Pool"

    @mandrill.messages.send_template template_name, template_content, message, async, ip_pool
  end
end
