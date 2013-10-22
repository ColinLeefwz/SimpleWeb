require 'mandrill'
require 'base64'

class MandrillApi
  def initialize
    @mandrill = Mandrill::API.new ENV['MANDRILL_API']
  end

  def enroll_comfirm(user, session, template_name, session_image_url)
    template_content = [{"name" => "first-name", "content" => user.first_name}, {"name" => "session-title", "content" => session.title }, {"name" => "expert-name", "content" => session.expert.name}, {"name" => "start-date", "content" => session.start_date }]

    message = {
      "merge_vars"=>
      [{"rcpt"=>user.email, "vars"=>[{"name"=>"SESSIONIMAGE", "content"=>session_image_url}, { "name"=>"SHARETWITTER", "content"=>"http://twitter.com/home?status=http://www.prodygia.com/sessions/#{session.id}" }, { "name"=>"SHAREFB", "content"=>"http://www.facebook.com/sharer/sharer.php?u=http://www.prodygia.com/sessions/#{session.id}" } ]}],
      "bcc_address"=>"message.bcc_address@example.com",
      "text"=>"Example text content",
      "metadata"=>{"website"=>"www.prodygia.com"},
      "view_content_link"=>nil,
      "auto_text"=>nil,
      "important"=>false,
      "to"=>[{"name"=>user.first_name, "email"=>user.email}],
      "tracking_domain"=>nil,
      "inline_css"=>nil,
      "headers"=>{"Reply-To"=>"no-reply@prodygia.com"}
    }

    async = false
    ip_pool = "Main Pool"

    @mandrill.messages.send_template template_name, template_content, message, async, ip_pool
  end

  def welcome_confirm(user)
    template_name = "welcome"
    template_content = [{"name" => "first-name", "content" => user.first_name}]

    message = {
      "merge_vars"=>
      [{"rcpt"=>user.email, "vars"=>[{"name"=>"SHARETWITTER", "content"=>"http://twitter.com/home?status=http://www.prodygia.com"}, { "name"=>"SHAREFB", "content"=>"http://www.facebook.com/sharer/sharer.php?u=http://www.prodygia.com" }]}],
      "bcc_address"=>"message.bcc_address@example.com",
      "text"=>"Example text content",
      "metadata"=>{"website"=>"www.prodygia.com"},
      "view_content_link"=>nil,
      "auto_text"=>nil,
      "important"=>false,
      "to"=>[{"name"=>user.first_name, "email"=>user.email}],
      "tracking_domain"=>nil,
      "inline_css"=>nil,
      "headers"=>{"Reply-To"=>"no-reply@prodygia.com"}
    }

    async = false
    ip_pool = "Main Pool"

    @mandrill.messages.send_template template_name, template_content, message, async, ip_pool
  end

  def invite_by_expert(user, email_message, token_link)
    template_name = "invite_expert"
    template_content = [{"name" => "message_content", "content" => email_message.message }, { "name"=>"invite_token", "content"=>token_link }]
    to_message = []
    if email_message.copy_me?
      cc_name = user.first_name
      cc_email = user.email
      to_message = [{"type"=>"to", "name" =>"", "email"=> email_message.to}, {"type"=>"cc", "name"=>cc_name, "email"=>cc_email}]
    else
      to_message = [{"type"=>"to", "name" =>"", "email"=> email_message.to}]
    end

    message = {
      "merge_vars"=>
      [{"rcpt"=>user.email, "vars"=>[{"name"=>"TOKEN_LINK", "content"=>token_link}]}],
      "from_name" => email_message.from_name,
      "from_email" => user.email,
      "subject" => email_message.subject,
      "bcc_address"=>"message.bcc_address@example.com",
      "text"=>"Example text content",
      "metadata"=>{"website"=>"www.prodygia.com"},
      "view_content_link"=>nil,
      "auto_text"=>nil,
      "important"=>false,
      "to"=>to_message,
      "tracking_domain"=>nil,
      "headers"=>{"Reply-To"=>user.email},
      "inline_css"=>nil,
      "headers"=>{"Reply-To"=>"no-reply@prodygia.com"}
    }

    async = false
    ip_pool = "Main Pool"

    @mandrill.messages.send_template template_name, template_content, message, async, ip_pool

  end

end
