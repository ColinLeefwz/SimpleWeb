require 'mandrill'
class MandrillApi
  def initialize
    @mandrill = Mandrill::API.new ENV['MANDRILL_API']
  end

  def template_send(template_name)
    merge_vars = [{"firstname" => "peterzd"}]

  end
end
