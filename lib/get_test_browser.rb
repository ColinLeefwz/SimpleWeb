
class GetTestBrowser

  def self.browser
    if RUBY_PLATFORM =~ /mswin32/
       "*iexplore" 
    else
       "*firefox"
    end
  end

end
