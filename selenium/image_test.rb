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

class ImageTest < Test::Unit::TestCase
  
  def setup
    @host = "http://shop.dface.cn"
    if RUBY_PLATFORM =~ /mswin32/
      @driver = Selenium::WebDriver.for :ie
    else
      @driver = Selenium::WebDriver.for :firefox
    end

  #login
  @driver.navigate.to @host + "/shop3_login/login"
  @driver.find_element(:name, 'id').rsend_keys "21836841"
  @driver.find_element(:name, 'password').rsend_keys "123456"
  @driver.find_element(:class, 'btn').click
  end

  def teardown
    images_index
    @driver.quit
  end

  #跳转到照片墙管理主页
  def images_index
    @driver.find_element(:link, "照片墙管理").click
  end

  #跳转到用户图片页
  def user_images
    @driver.find_element(:link, "用户图片").click
  end

  #跳转到商家图片页
  def shop_images
    @driver.find_element(:link, "商家图片").click
  end

  #上传商家图片
  def shop_image_upload
    #隐藏元素不能操作， 先把文件输入框显示
    @driver.execute_script("document.getElementById('shop_photo_img').setAttribute('class', '')")
    #图片上传路径
    img_path = File.expand_path("../..", __FILE__)+ "/public/images/test/test.jpg"
    #图片上传
    @driver.find_element(:xpath, "//input[@id='shop_photo_img']").send_keys(img_path)
    #隐藏元素
    @driver.execute_script("document.getElementById('shop_photo_img').setAttribute('class', 'filebox1')")
  end

  def test_login
    images_index #跳转到照片墙管理主页

###############用户图片页
    user_images #跳转到用户图片页

    #图片详情
    element = @driver.find_element(:class, "box9plane")
    element.first(:class, "n1").click
    assert_equal @driver.current_url, @host+"/shop3_content/show_photo?id=52663ce4c90d8ba9f300001b"

    @driver.find_element(:lick, "星魂").click
    assert_equal @driver.current_url, @host+"/shop3_checkins/user?uid=51910153c90d8b1e2000015e"
    @driver.find_element(:class, "btn10").click #返回照片详情页
    sleep(3)

    #图片隐藏
    element = @driver.find_element(:class, "box9plane")
    element.first(:class, "n4").click
    assert_equal @driver.find_element(:class, "bm").count,1
    element = @driver.find_element(:class, "box9plane")
    element.first(:class, "n5").click #显示回来
    sleep(3)
    
    #图片置顶
    element = @driver.find_element(:class, "box9plane")
    element.last(:class, "n2").click
    element.last(:class, "n1").click
    assert_equal @driver.current_url, @host+"/shop3_content/show_photo?id=52663ce4c90d8ba9f300001b"
    element.first(:class, "n2").click #还原置顶
    sleep(3)

 ###############商家图片页

    #不传商家图片, 提示请上传请上传图片
    shop_images

    @driver.find_element(:id, "photo_desc").rsend_keys "商家描述，商家描述，商家描述，商家描述，商家描述，商家描述"
    @driver.find_element(:name, "Submit").click
    assert_equal @driver.find_element(:class, 'orange1').text, "请上传图片" 
    sleep(3)

    #传商家图片
    shop_image_upload
    @driver.find_element(:name, "Submit").click
    assert_equal @driver.current_url @host + "/shop3_content/shop_photo"
    assert_equal @driver.find_element(:class, "box9plane").count,1 #商家图片数量为1
    sleep(3)

    #删除商家图片
    element = @driver.find_element(:class, "box9plane")
    element.first(:class, "n6").click
    assert_equal @driver.find_element(:class, "box9plane").count,0 #商家图片数量为0
  end
end

  







