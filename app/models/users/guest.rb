class Guest
  attr_accessor :email, :subscribe_newsletter, :first_name, :last_name

  def initialize
    @subscribe_newsletter = false
    @first_name = "A"
    @last_name = "GUEST"
  end

  def method_missing(method_name, *args, &block)
  end
end
