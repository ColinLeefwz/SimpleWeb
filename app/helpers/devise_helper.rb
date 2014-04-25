module DeviseHelper

  ## overridden from Devise source code
  # https://github.com/plataformatec/devise/blob/master/app/helpers/devise_helper.rb
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = "Oops! Your changes could not be saved for the following reason(s):"

    html = <<-HTML
    <div class="alert alert-danger alert-block">
      <button type="button" class="close" data-dismiss="alert">x</button>
      <h4>#{sentence}</h4>
      #{messages}
    </div>
    HTML

    html.html_safe
  end
end
