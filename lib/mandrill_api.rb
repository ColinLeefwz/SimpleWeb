require 'mandrill'
require 'base64'

class MandrillApi
  def initialize
    @mandrill = Mandrill::API.new ENV['MANDRILL_API']
  end


  def enroll_comfirm(user, session, session_image_url)

    template_content = [{"name" => "first-name", "content" => user.first_name}, {"name" => "session-title", "content" => session.title }, {"name" => "expert-name", "content" => session.expert.name}, {"name" => "start-date", "content" => session.start_date }]

    addition_message = {
      "merge_vars"=>
      [{"rcpt"=>user.email, "vars"=>[{"name"=>"SESSIONIMAGE", "content"=>session_image_url}, { "name"=>"SHARETWITTER", "content"=>"http://twitter.com/home?status=http://www.prodygia.com/sessions/#{session.id}" }, { "name"=>"SHAREFB", "content"=>"http://www.facebook.com/sharer/sharer.php?u=http://www.prodygia.com/sessions/#{session.id}" } ]}],
      "to"=>[{"name"=>user.first_name, "email"=>user.email}],
    }

    send_template_mail("enroll_comfirm", template_content, addition_message)
  end

  def welcome_confirm(user)
    template_content = [{"name" => "first-name", "content" => user.first_name}]

    addition_message = {
      "merge_vars"=>
      [{"rcpt"=>user.email, "vars"=>[{"name"=>"SHARETWITTER", "content"=>"http://twitter.com/home?status=http://www.prodygia.com"}, { "name"=>"SHAREFB", "content"=>"http://www.facebook.com/sharer/sharer.php?u=http://www.prodygia.com" }]}],
      "to"=>[{"name"=>user.first_name, "email"=>user.email}],
    }

    send_template_mail("welcome", template_content, addition_message)
  end

  def invite_by_expert(user, email_message, token_link)
    template_content = [{"name" => "message_content", "content" => email_message.message }, { "name"=>"token_link", "content"=>"<a href='#{token_link}'>#{token_link}</a>"}]

    to_message = []
    if email_message.copy_me?
      cc_name, cc_email = user.first_name, user.email
      to_message = [{"type"=>"to", "name" =>"", "email"=> email_message.to}, {"type"=>"cc", "name"=>cc_name, "email"=>cc_email}]
    else
      to_message = [{"type"=>"to", "name" =>"", "email"=> email_message.to}]
    end

    addition_message = {
      "from_name" => email_message.from_name,
      "from_email" => "no-reply@prodygia.com",
      "subject" => email_message.subject,
      "to"=>to_message,
      "headers"=>{"Reply-To"=>user.email}
    }

    send_template_mail("invite_expert", template_content, addition_message)
  end

	def reset_password(user, reset_link)
		template_content = [{"name" => "reset-link", "content" => "<a href='#{reset_link}'>#{reset_link}</a>"}, {"name"=>"first-name", "content"=>user.first_name}, {"name"=>"email-address", "content"=>user.email}]

		addition_message = {
			"to"=>[{"name"=>user.first_name, "email"=>user.email}]
		}
		
    send_template_mail("reset_password", template_content, addition_message)

	end

  protected

  def send_template_mail(template_name, template_content, addition_message = {})
    basic_message = {
      "text"=>"Example text content",
      "metadata"=>{"website"=>"www.prodygia.com"},
      "view_content_link"=>nil,
      "auto_text"=>nil,
      "important"=>false,
      "tracking_domain"=>nil,
      "inline_css"=>nil,
      "headers"=>{"Reply-To"=>"no-reply@prodygia.com"}
    }

    message = basic_message.merge! addition_message

    async = false
    ip_pool = "Main Pool"

    @mandrill.messages.send_template template_name, template_content, message, async, ip_pool
  end

end
