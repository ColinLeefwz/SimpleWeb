# coding: utf-8
require "test/unit"
require "rubygems"
require "selenium-webdriver"


class LoginTest < Test::Unit::TestCase

  def setup
    if RUBY_PLATFORM =~ /mswin32/
      @driver = Selenium::WebDriver.for :ie
    else
      @driver = Selenium::WebDriver.for :firefox
    end
  end

  def teardown
    @driver.quit
  end

  def test_login
    
    @driver.navigate.to "http://shop.dface.cn/shop_login/login"

    #错误id
    @driver.find_element(:name, 'id').send_keys "21835801343434"
    @driver.find_element(:name, 'password').send_keys "123456"
    @driver.find_element(:class, 'btn').click
    assert_equal @driver.find_element(:id, 'Notice').text, 'id没有找到.'

    #密码错误
    element = @driver.find_element(:name, 'id')
    element.clear
    element.send_keys "21836841"
    element = @driver.find_element(:name, 'password')
    element.clear
    element.send_keys "123456343"
    @driver.find_element(:class, 'btn').click
    assert_equal @driver.find_element(:id, 'Notice').text, '密码输入错误，您还有9次机会'

    #成功登录
    element=@driver.find_element(:name, 'id')
    element.clear
    element.send_keys "21836841"
    element=@driver.find_element(:name, 'password')
    element.clear
    element.send_keys "123456"
    @driver.find_element(:class, 'btn').click
    assert_equal  @driver.title, 'selenium测试专用欢迎您'

    #退出登录
    @driver.find_element(:link, '退出').click
    assert_equal @driver.current_url, 'http://shop.dface.cn/shop3_login/login'


  end
end