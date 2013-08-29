module WelcomeHelper
  def number_column (session)
    first = Array.new
    second = Array.new
    third = Array.new
    total = Array.new
    if session.id % 3 == 1
      first << session
    elsif session.id % 3 == 2
      second << session
    elsif session.id % 3 == 0
      third << session
    end
    total << first
    total << second
    total << third
  end
end
