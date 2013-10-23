# coding: utf-8
require "test/unit"
require "rubygems"
require "selenium-webdriver"
class Selenium::WebDriver::Element
  def rsend_keys(*args)
    clear
    send_keys(args)
  end
end

class  SeleniumTest < Test::Unit::TestCase

  def get_browser
    browser = ENV["selenium_browser"] || (RUBY_PLATFORM =~ /mswin32/ ? "ie" : "firefox")
    browser.to_sym
  end

  def setup
    #    @host = "http://127.0.0.1"
    @host = "http://shop.dface.cn"
    @driver = Selenium::WebDriver.for get_browser
  end

  def teardown
    @driver.quit
  end
  
end