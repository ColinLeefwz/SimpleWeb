require 'mandrill'
require 'base64'

class MandrillApi
  def initialize
    @mandrill = Mandrill::API.new ENV['MANDRILL_API']
  end

  def enroll_confirm(user, item, item_cover)

    #todo: change "session-title" to "item-title" (confirm with peter)
    #todo: course.start_date
    template_content = [{"name" => "first-name", "content" => user.first_name}, {"name" => "session-title", "content" => item.title }, {"name" => "expert-name", "content" => item.producers}, {"name" => "start-date", "content" => item.try(:start_date) }]

    addition_message = {
      "merge_vars"=>
      [{"rcpt"=>user.email, "vars"=>[{"name"=>"SESSIONIMAGE", "content"=> item_cover}, { "name"=>"SHARETWITTER", "content"=>"http://twitter.com/home?status=http://www.prodygia.com/sessions/#{item.id}" }, { "name"=>"SHAREFB", "content"=>"http://www.facebook.com/sharer/sharer.php?u=http://www.prodygia.com/sessions/#{item.id}" } ]}],
      "to"=>[{"name"=>user.first_name, "email"=>user.email}],
    }

    send_template_mail("enroll-confirm", template_content, addition_message)
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

  ##Peter at 2014-03-04: the two methods below seems the same, but only the template_name(slug_name)
  # why not merge them ?
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

    send_template_mail("invite-expert", template_content, addition_message)
  end

  def invite_by_member(user, email_message, token_link)
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

    send_template_mail("refer-a-friend", template_content, addition_message)
  end

  def reset_password(user, reset_link)
    template_content = [{"name" => "reset-link", "content" => "<a href='#{reset_link}'>#{reset_link}</a>"}, {"name"=>"first-name", "content"=>user.first_name}, {"name"=>"email-address", "content"=>user.email}]

    addition_message = {
      "to"=>[{"name"=>user.first_name, "email"=>user.email}]
    }

    send_template_mail("reset-password", template_content, addition_message)

  end

  def email_friend_session(email_content, session_link)
    from_name = email_content[:your_name]
    from_address = email_content[:your_address]
    to_name = email_content[:to_name]
    to_address = email_content[:to_address]
    content = email_content[:content]

    template_content = [{"name"=> "to-name", "content" => to_name}, {"name" => "from-name", "content" => from_name}, {"name"=> "session-link", "content" => "<a href='#{session_link}'>#{session_link}</a>"}, {"name"=>"want-to-say", "content"=> content}]

    addition_message = {
      "from_name" => from_name,
      "from_email" => from_address,
      "to"=>[{"name"=> to_name, "email" => to_address}],
      "headers" => { "Reply-To"=> from_address}
    }

    send_template_mail("tell-friend", template_content, addition_message)
  end

  def consultation_pending_mail(consultation)
    requester_name = consultation.requester.name
    consultant_name = consultation.consultant.name
    template_content = [{"name"=> "requester-name", "content" => requester_name}, {"name" => "consultant-name", "content" => consultant_name}]

    addition_message = (Rails.env.development?) ? {"to"=>[{"name"=> "peterzd", "email" => "zdsunshine0640@126.com"}]} : {"to"=>[{"name"=> "Prodygia Admin", "email" => "support@prodygia.com"}]}

    send_template_mail("consultation-pending", template_content, addition_message)
  end

  def consultation_processed_mail(consultation)
    consultant = consultation.consultant
    requester_name = consultation.requester.name
    consultant_name = consultation.consultant.name
    template_content = [{"name"=> "requester-name", "content" => requester_name}, { "name" => "consultant-name", "content" => consultant_name}]

    addition_message = {
      "to"=>[{"name"=> consultant.name, "email" => consultant.email}]
    }

    send_template_mail("consultation-processed", template_content, addition_message)
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
