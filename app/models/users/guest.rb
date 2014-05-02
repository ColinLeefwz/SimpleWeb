class Guest
  attr_accessor :id, :email, :subscribe_newsletter, :first_name, :last_name

  def initialize(email="foo@bar.com")
    @subscribe_newsletter = false
    @first_name = ""
    @last_name = ""
    @email = email
    @id = nil
  end

  def method_missing(method_name, *args, &block)
    self
  end
end
